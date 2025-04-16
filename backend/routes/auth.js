const express = require("express");
const User = require('../models/user')
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken')
const {auth} = require('../middleware/auth')
const authRouter = express.Router();
const Vendor = require('../models/vendor')
const sendOTPEmail = require('../helpers/send_email');
const crypto = require('crypto');


const otpStore = new Map();

authRouter.post('/api/signup', async (req,res) => {
    try{
        const {fullName, email, password} = req.body;
        
        //check if the account has been created by a vendor before

        const existingVendorEmail = await Vendor.findOne({email});

        if(existingVendorEmail){
            return res.status(400).json({msg: "account already own by a vendor"})
        }

        const response = await User.findOne({email});
        if(response){
            return res.status(400).json({msg: "user with same email already exist"});
        } else {

           const salt = await bcrypt.genSalt(10);
           const hashedPassword = await bcrypt.hash(password, salt);
           //Generate OTP
           const otp = crypto.randomInt(100000,999999);

           //Save otp in the temporary store with email as key
           otpStore.set(email, {otp, expiresAt: Date.now()+ 30*60*1000}); //expires in 10 minutes


           let user = new User({fullName, email, password: hashedPassword, isVerified: false});
           user = await user.save();



           // Send OTP via email
          emailResponse = await sendOTPEmail(email, otp);

           res.status(201).json({msg: "Sign Up Successful , OTP send to email", emailResponse})
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
});

//signin api endpoint 

authRouter.post('/api/signin', async (req,res) => {
    try{
        const {email, password} = req.body;
        const findUser = await User.findOne({email});
        if(!findUser){
            return res.status(400).json({msg: "user not Found with this email"});
            
        } //check if user is verified
        
        if(!findUser.isVerified){
            return res.status(403).json({msg: "email not verified. Please verify your email to sign in"})
        }
        
        else {
           const isMatch = await bcrypt.compare(password,findUser.password);
           if(!isMatch){
            return res.status(400).json({msg: "incorrect password"})
           } else {

            //set the token to expire in 1 minute

             const token = jwt.sign({id:findUser._id}, "passwordKey", {expiresIn: '30m'});

             //remove sensitive information
             const {password, ...userWithoutPassword} = findUser._doc; 

             
             res.json({token, user: userWithoutPassword })
           }
        }
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

//check token validity
authRouter.post('/tokenIsValid', async(req,res) => {
    try{
        const token = req.header("x-auth-token");
        if(!token){
            return res.json(false);
        }
        //verify the token
      const verified = jwt.verify(token, 'passwordKey');
      if(!verified){
        return res.json(false);
      }

      //if verification failed(expired or invalid), jwt verify will thorw an error

     const user = await User.findById(verified.id);

    if(!user)
        return res.json(false);

    return res.json(true)

    }catch(e){
    // jwt.verify fails or any other errors occurs, return false

    return res.status(500).json({error: e.message})

    }
})

//Define a Get Route for the authentication router

authRouter.get("/", auth, async (req,res) => {
    try{
        //retrive the user database using the id from the authenticated user
        const user = await User.findById(req.user);

        //send the user data as json response, including all the user document fields and the token

       return res.json({...user._doc, token: req.token});
    }catch(e){
        return res.status(500).json({error:e.message});
    }
})

//verify OTP Route
authRouter.post('/api/verify-otp', async (req,res)=> {
    try{
        const {email, otp } = req.body;

        //check if OTP exist and if it is valid

        const storedOtpData = otpStore.get(email);
        if(!storedOtpData){
            return res.status(400).json({msg: "OTP not found or expired"});
        }

        if(storedOtpData.otp!==Number(otp)){
            return res.status(400).json({msg: "invalid OTP"})
        }

        // check if OTP has expired

        if(storedOtpData.expiresAt < Date.now()){
            otpStore.delete(email);
            return res.status(400).json({msg: "OTP has expired"})
        } 

        //Mark user as verified

        const user =  await User.findOneAndUpdate({email}, {isVerified: true}, {new: true});

        if(!user){
            return res.status(400).json({msg: "User not found"})
        }

        otpStore.delete(email);

        //

        return res.status(200).json({msg: "Email verification successfully", user});
        
    }catch(e){
        return res.status(500).json({error: e.message});
    }
})

authRouter.put('/api/users/:id', async (req,res)=> {
    try{
        const {id} = req.params;
        const {state, city, locality} = req.body;

        const updateUser = await User.findByIdAndUpdate(
            id, 
            {state, city, locality},
            {new: true}
        ); 

        if(!updateUser){
            return res.status(404).json({error: "User not found"})
        }
        return res.status(200).json(updateUser);
        
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

//fetch all users(exclude password)
authRouter.get('/api/users', async (req,res) => {
    try{
        const users = await User.find().select('-password');
        return res.status(200).json(users);
    }catch(e){
        res.status(500).json({error: e.message}); 
    }
})

authRouter.delete('/api/user/delete-account/:id',auth, async (req,res) => {
    try{

        //Extract the ID from the request parameter
        const {id} = req.params;

        const user = await User.findById(id);
        const vendor = await Vendor.findById(id);

        if(!user && !vendor){
            return res.status(404).json({msg: "user or vendor not found"})
        }

    // Delete the user o vendor based on their type

    if(user){
        await User.findByIdAndDelete(id);
   
    } else if(vendor){
        await Vendor.findByIdAndDelete(id)
    } 

    return res.status(200).json({msg: "User deleted successfully"});

    }catch(e){
        return res.status({error:e.message});
    }
})

module.exports = authRouter;
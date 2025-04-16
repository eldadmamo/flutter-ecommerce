const express = require('express');
const Vendor = require('../models/vendor')
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken')
const User = require('../models/user');
const {auth} = require('../middleware/auth')

const vendorRouter = express.Router();


vendorRouter.post('/api/v2/vendor/signup', async (req,res) => {
    try{
        const {fullName, email,  storeName, storeImage, storeDescription, password} = req.body;

        // check if the email already exists in the regular users collection
        const existingUserEmail = await User.findOne({email});

        if(existingUserEmail){
            return res.status(400).json({msg: "A user with the same email already exist in our system"})
        }
        
        const response = await Vendor.findOne({email});
        if(response){
            return res.status(400).json({msg: "user with same email already exist"});
        } else {
           const salt = await bcrypt.genSalt(10);
           const hashedPassword = await bcrypt.hash(password, salt);
           let vendor = new Vendor({fullName, email, storeName, storeImage, storeDescription, password: hashedPassword});
           vendor = await vendor.save()
           res.json({vendor});
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
});

//signin api endpoint 

vendorRouter.post('/api/v2/vendor/signin', async (req,res) => {
    try{
        const {email, password} = req.body;
        const findUser = await Vendor.findOne({email});
        if(!findUser){
            return res.status(400).json({msg: "vendor not Found with this email"});
        } else {
           const isMatch = await bcrypt.compare(password,findUser.password);
           if(!isMatch){
            return res.status(400).json({msg: "incorrect password"})
           } else {
             const token = jwt.sign({id:findUser._id}, "passwordkey",{expiresIn: '1m'});

             //remove sensitive information
             const {password, ...vendorWithoutPassword} = findUser._doc; 

             
             res.json({token, vendorWithoutPassword })
           }
        }
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

vendorRouter.post('/vendor-tokenIsValid', async(req,res) => {
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

     const vendor = await Vendor.findById(verified.id);

    if(!vendor){
        return res.json(false);
    }
        

    return res.json(true)

    }catch(e){
    // jwt.verify fails or any other errors occurs, return false

    return res.status(500).json({error: e.message})

    }
})


vendorRouter.get("/get-vendor", auth, async (req,res) => {
    try{
        //retrive the user database using the id from the authenticated vendor
        const vendor = await Vendor.findById(req.user);

        //send the user data as json response, including all the user document fields and the token

       return res.json({...vendor._doc, token: req.token});
    }catch(e){
        return res.status(500).json({error:e.message});
    }
})


//Fetch all vendors(exclude password)
vendorRouter.get('/api/vendors', async (req,res)=> {
    try{
        const vendors = await Vendor.find().select('-password');
        return res.status(200).json(vendors);
    }catch(e){
        res.status(500).json({error: e.message});
    }
})
module.exports = vendorRouter;
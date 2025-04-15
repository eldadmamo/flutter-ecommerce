const express = require("express");
const User = require('../models/user')
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken')

const authRouter = express.Router();
const sendWelcomeEmail = require('../helpers/send_email');


authRouter.post('/api/signup', async (req,res) => {
    try{
        const {fullName, email, password} = req.body;
        
        const response = await User.findOne({email});
        if(response){
            return res.status(400).json({msg: "user with same email already exist"});
        } else {

           const salt = await bcrypt.genSalt(10);
           const hashedPassword = await bcrypt.hash(password, salt);
           let user = new User({fullName, email, password: hashedPassword});
           user = await user.save()
           res.json({user});
           sendWelcomeEmail(email);
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
        } else {
           const isMatch = await bcrypt.compare(password,findUser.password);
           if(!isMatch){
            return res.status(400).json({msg: "incorrect password"})
           } else {
             const token = jwt.sign({id:findUser._id}, "passwordkey");

             //remove sensitive information
             const {password, ...userWithoutPassword} = findUser._doc; 

             
             res.json({token, user: userWithoutPassword })
           }
        }
    }catch(e){
        res.status(500).json({error: e.message})
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

module.exports = authRouter;
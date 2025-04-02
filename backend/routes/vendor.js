const express = require('express');
const Vendor = require('../models/vendor')
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken')

const vendorRouter = express.Router();


vendorRouter.post('/api/vendor/signup', async (req,res) => {
    try{
        const {fullName, email, password} = req.body;
        
        const response = await Vendor.findOne({email});
        if(response){
            return res.status(400).json({msg: "user with same email already exist"});
        } else {
           const salt = await bcrypt.genSalt(10);
           const hashedPassword = await bcrypt.hash(password, salt);
           let vendor = new Vendor({fullName, email, password: hashedPassword});
           vendor = await vendor.save()
           res.json({vendor});
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
});

//signin api endpoint 

vendorRouter.post('/api/vendor/signin', async (req,res) => {
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
             const token = jwt.sign({id:findUser._id}, "passwordkey");

             //remove sensitive information
             const {password, ...vendorWithoutPassword} = findUser._doc; 

             
             res.json({token, vendor: vendorWithoutPassword })
           }
        }
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

module.exports = vendorRouter;
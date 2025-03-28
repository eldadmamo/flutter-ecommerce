const express = require('express');
const Banner = require('../models/banner');

const bannerRouter = express.Router();

bannerRouter.post('/api/banner', async (req,res) => {
    try{
        const {image} = req.body;
        const banner = new Banner({image});
        await banner.save();
        return res.status(201).send(banner);
    }catch(e){
        res.status(500).json({error:e.message});
    }
});

bannerRouter.get('/api/banners', async (req,res) => {
    try{
      const banner = await Banner.find();
      return res.status(200).send(banner)
    } catch(error){
        res.status(500).json({error: e.message})
    }
})

module.exports = bannerRouter; 
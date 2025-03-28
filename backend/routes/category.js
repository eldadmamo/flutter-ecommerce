const express = require('express');

const Category = require('../models/category');

const cateogryRouter = express.Router();

cateogryRouter.post('/api/categories', async (req, res) => {
    try{
        const {name, image, banner} = req.body;
        const category = new Category({name,image, banner});
        await category.save();
        return res.status(200).send(category);
    }catch(e){
        res.status(400).json({error: e.message})
    }
})

cateogryRouter.get('/api/categories', async (req, res) => {
    try{
        const category = await Category.find();
        return res.status(200).send({category});
    }catch(e){
        res.staus(500).json({error: e.message})
    }
})

module.exports = cateogryRouter;


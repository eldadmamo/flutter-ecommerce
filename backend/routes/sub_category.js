const express = require("express");
const subCategory = require('../models/sub_categories');

const subcategoryRouter = express.Router();

subcategoryRouter.post('/api/subcategories', async (req, res) => {
    try{
        const {categoryId, categoryName, image, subCategoryName} = req.body;
        const subcategory = new subCategory({categoryId, categoryName, image, subCategoryName});
        await subcategory.save();
        res.status(201).send(subcategory);
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

subcategoryRouter.get('/api/subcategories', async (req, res) => {
     try{
        const subcategories = await subCategory.find();
         return res.status(200).send(subcategories);
    } catch(e){
        res.status(500).json({error: e.message})
    }
})

subcategoryRouter.get('/api/category/:categoryName/subcategories', async (req, res) => {
    const {categoryName} = req.params;
    
    try{
        const subcategories = await subCategory.find({categoryName});
    if(!subcategories || subcategories.length == 0){
        res.status(404).json({msg: 'subcategories is not Found'})
    } else {
        res.status(200).send(subcategories);
    }
    
    } catch(e){
        res.status(500).json({error: e.message})
    }
})

module.exports = subcategoryRouter;
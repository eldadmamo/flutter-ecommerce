const express = require("express");
const Product = require('../models/product');
const {auth,vendorAuth} = require('../middleware/auth');

const productRouter = express.Router();

productRouter.post('/api/add-product',auth,vendorAuth, async (req, res) => {
    try{
        const {productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images} = req.body;

        const product = new Product({productName, productPrice, quantity, description, category, vendorId,fullName, subCategory, images});
        await product.save();
        res.status(200).send(product);
    }catch(e){
        res.status(400).json({error: e.message});
    }
})


productRouter.get('/api/popular-products', async (req, res) => {
    try{
       const product = await Product.find({popular: true});
        if(!product && product.length == 0){
            return res.status(404).json({msg:"products not found"})
        } else {
            return res.status(200).json({product});
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
})

productRouter.get('/api/recommended-products', async (req, res) => {
    try{
       const product = await Product.find({recommend: true});
        if(!product && product.length == 0){
            return res.status(404).json({msg:"products not found"})
        } else {
            return res.status(200).json({product});
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
})

// new router for retriving products by category 
productRouter.get('/api/products-by-category/:category', async(req, res) => {
    try{
        const {category} = req.params;
        const products = await Product.find({category, popular: true});
        if(!products || products.length==0){
            return res.status(404).json({msg: "Product not found"})
        } else {
            return res.status(200).json(products)
        }
    }catch(e){
        res.status(500).json({error: e.message});
    }
})


productRouter.get('/api/related-products-by-subcategory/:productId', async (req,res)=> {
    try{
    const {productId} = req.params;
    const product = await Product.findById(productId);
    if(!product){
        return res.status(404).json({msg: "Product not found"})
    } else {
       const relatedProducts =  await Product.find({
            subCategory: product.subCategory, 
            _id: {$ne:productId} //exclude the current product
        });

        if(!relatedProducts || relatedProducts.length == 0){
            return res.status(404).json({msg: "No related products found"})
        }
        return res.status(200).json(relatedProducts);

    }
    }catch(e){
        return res.status(500).json({error:e.message});
    }
})

productRouter.get('/api/top-rated-products', async (req,res) => {
    try{

        const topRatedProducts = await Product.find({}).sort({averageRating: -1}).limit(10) //sort product by averageRating, with indicating decending

        if(!topRatedProducts || topRatedProducts.length == 0){
            return res.status(404).json({msg: "No top-rated products found"})
        }
        //return the top-rated product as a response 
        return res.status(200).json(topRatedProducts);
 
    }catch(e){
        return res.status(500).json({error:e.message})
    }
});

productRouter.get('/api/products-by-subcategories/:subCategory', async (req,res)=> {
    try{
        const {subCategory} = req.params;
       const products = await Product.find({subCategory: subCategory});
       if(!products || products.length == 0){
        return res.status(404).json({msg: "No Products found in this subcategory"})
       } 
       return res.status(200).json(products);
    }catch(error){
       return res.status(500).json({error: e.message});  
    }
})

//Route for searching products by name or description
productRouter.get('/api/search-products', async(req,res)=>{
    try{

        const {query} = req.params;

        if(!query){
            return res.status(400).json({msg: "Query parameter required"})
        }

        const products = await Product.find({
            $or: [
                // Regex will match any productName containing, the query String, 
                // For example, if the user search for "apple", the regex will check
                // if "apple" is part of any productName, so products name "Green Apple pie",
                // or "Fresh Apples", would all match because they contain the word "apple"
              {productName: {
                $regex: query,
                $options: 'i'
               }},
              {description: {
                $regex: query,
                $options: 'i'
               }},
            ]
        });

        // check if any products were found, if not product match the query
        // return a 404 status code with a message
        if(!products || products.length==0){
            return res.status(404).json({msg: "No Product found matching the query"})
        }

        return res.status(200).json(products);
    }catch(error){
        return res.status(500).json({error: e.message})
    }
})

productRouter.put("/api/edit-product/:productId",auth, vendorAuth, async (req,res)=> {
    try{
        //Extract product Id from the request parameter
        const {productId} = req.params;
        const product = await Product.find(productId);
        if(!product){
            return res.status(404).json({msg: "Product not found"});
        }
        if(product.vendorId.toString()!== req.user.id){
            return res.status(403).json({msg: "Unauthorized to edit the product"})
        }

        //Destructive req.body to exclude vendorId

        const {vendorId, ...updateData} = req.body;
        
       const updateProduct = await Product.findByIdAndUpdate(
            productId,
            {$set: updateData}, //update only fields in the updateData
            {new: true}
        )

        return res.status(200).json(updateProduct);
    }catch(e){
        return res.status(500).json({error: e.message});
    }
})


module.exports = productRouter;
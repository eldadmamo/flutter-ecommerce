const express = require('express');
const orderRouter = express.Router();
const Order = require('../models/order');

//Post router for createing orders

orderRouter.post('/api/orders', async (req, res) => {
    try{
        const {fullName, email,state,city,locality,productName,productPrice,quantity,category,image,buyerId,vendorId} = req.body;
        const createdAt = new Date().getMilliseconds();

        const order = new Order({
            fullName,
            email,state,city,locality,productName,productPrice,quantity,category,image,buyerId,vendorId, createdAt
        });
         await order.save();
         return res.status(201).json(order);
    }catch(e){
        res.staus(500).json({error: e.message});
    }
})

//Get Route for fetching 

orderRouter.get('/api/orders/:buyerId', async (req, res) => {
    try{
        //extract the buyer from request paramerts
        const {buyerId} =req.params;
        const orders = await Order.find({buyerId});

        if(orders===0){
            return res.status(404).json({msg: "No Orders found for this buyer"});
        }
        //If orders are found, return them with a 200 status code
        return res.status(200).json(orders);
    }catch(error){
        //Handle any errors that occure during the order retrieval process
        res.status(500).json({error: e.message});
    }
})

orderRouter.delete("/api/orders/:id", async (req,res) => {
    try{
        const {id} = req.params;
        const deleteOrder = await Order.findByIdAndDelete(id);

        if(!deleteOrder){
            return res.status(404).json({msg: "not found"});
        } else {
            return res.status(200).json({msg: "Order was deleted Successfully"});
        }
    }catch(e){
        return res.status(500).json({error: e.message});
    }
})


orderRouter.get('/api/orders/vendors/:vendorId', async (req, res) => {
    try{
        //extract the buyer from request paramerts
        const {vendorId} =req.params;
        const orders = await Order.find({vendorId});

        if(orders===0){
            return res.status(404).json({msg: "No Orders found for this vendor"});
        }
        //If orders are found, return them with a 200 status code
        return res.status(200).json(orders);
    }catch(error){
        //Handle any errors that occure during the order retrieval process
        res.status(500).json({error: e.message});
    }
})

orderRouter.patch('/api/orders/:id/delivered', async(req,res)=> {
    try{
        const {id} = req.params;
       const updatedOrder = await Order.findByIdAndUpdate(
            id, 
            {delivered: true},
            {new:true}
      );

      if(!updatedOrder){
        return res.status(404).json({msg: "Order not found"})
      }  else {
        return res.status(200).json(updatedOrder);
      }
      
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

orderRouter.patch('/api/orders/:id/processing', async(req,res)=> {
    try{
        const {id} = req.params;
       const updatedOrder = await Order.findByIdAndUpdate(
             id, 
            {processing: false} ,
            {new:true}
      );

      if(!updatedOrder){
        return res.status(404).json({msg: "Order not found"})
      }  else {
        return res.status(200).json(updatedOrder);
      }
      
    }catch(e){
        res.status(500).json({error: e.message})
    }
})




module.exports = orderRouter;








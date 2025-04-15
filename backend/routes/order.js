const express = require('express');
const orderRouter = express.Router();
const Order = require('../models/order');
const {auth,vendorAuth} = require('../middleware/auth')
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY)

//Post router for createing orders

orderRouter.post('/api/orders',auth, async (req, res) => {
    try{
        const {fullName, email,state,city,locality,productName,productPrice,quantity,category,image,buyerId,vendorId ,
            paymentStatus,
            paymentIntentId,
            paymentMethod,
        } = req.body;
        const createdAt = new Date().getMilliseconds();

        const order = new Order({
            fullName,
            email,state,city,locality,productName,productPrice,quantity,category,image,buyerId,vendorId, createdAt,
            paymentStatus,
            paymentIntentId,
            paymentMethod,
        });
         await order.save();
         return res.status(201).json(order);
    }catch(e){
        res.status(500).json({error: e.message});
    }
})

//Payment api
orderRouter.post('/api/payment', async (req,res) => {
    try{
      const {orderId, paymentMethodId, currency='usd'} = req.body;
      //validate the presence of the required fields
      if(!orderId || !paymentMethodId || !currency){
        return res.status(400).json({msg: "Missing required fields"})
      }  

      // Query for the order by orderId
      const order = await Order.findById(orderId);
      if(!order){
        console.log("order not found", orderId);
        return res.status(404).json({msg:"Order not found"})
      }

      // calculate 
      const totalAmount = order.productPrice * order.quantity;

      //Ensure the amount is at least $0.50 usd or its equivalent
      const minimumAmount = 0.50;
      if(totalAmount< minimumAmount){
        return res.status(400).json({error: 'Amount must be at least $0.50 USD'})
      }
      //con

      const amountInCents = Math.round(totalAmount * 100);

      const paymentIntent = await stripe.paymentIntents.create({
        amount: amountInCents, 
        currency: currency,
        payment_method: paymentMethodId,
        automatic_payment_methods:{enabled:true},
      });

      return res.json({
        status: "success",
        paymentIntentId: paymentIntent.id,
        amount: paymentIntent.amount/100, 
        current: paymentIntent.currency,
      })

    }catch(e){
        return res.status(500).json({error:e.message});
    }
})

orderRouter.post('/api/payment-intent', auth, async(req,res)=> {
    try{
        const {amount, currency} = req.body;

        const paymentIntent = await stripe.paymentIntents.create({
            amount, 
            currency
        });

        return res.status(200).json(paymentIntent);
    }catch(e){
        return res.status(500).json({error: e.message})
    }
});

orderRouter.get('/api/payment-intent/:id', auth, async (req,res) => {
    try{
        const paymentIntent = await stripe.paymentIntents.retrieve(req.params.id);
        return res.status(200).json(paymentIntent);
    }catch(e){
        res.status(500).json({error: e.message})
    }
})

//Get Route for fetching 

orderRouter.get('/api/orders/:buyerId',auth, async (req, res) => {
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

orderRouter.delete("/api/orders/:id",auth, async (req,res) => {
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


orderRouter.get('/api/orders/vendors/:vendorId',auth,vendorAuth, async (req, res) => {
                 
    try{
        //extract the buyer from request paramerts
        const {vendorId} =req.params;
        const orders = await Order.find({vendorId});

        if(orders.length===0){
            return res.status(404).json({msg: "No Orders found for this vendor"});
        }
        //If orders are found, return them with a 200 status code
        return res.status(200).json(orders);
    }catch(e){
        //Handle any errors that occure during the order retrieval process
        res.status(500).json({error: e.message});
    }
})

orderRouter.patch('/api/orders/:id/delivered', async(req,res)=> {
    try{
        const {id} = req.params;
       const updatedOrder = await Order.findByIdAndUpdate(
            id, 
            {delivered: true, processing: false},
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
            {processing: false, delivered: false},
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

orderRouter.get('/api/orders', async (req,res) => {
    try{
        const orders = await Order.find();
        res.status(200).json(orders);
    }catch(e){
        res.status(500).json({error: e.message})
    }
})




module.exports = orderRouter;








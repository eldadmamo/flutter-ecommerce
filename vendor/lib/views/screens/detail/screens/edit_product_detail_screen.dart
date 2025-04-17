import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/controllers/product_controller.dart';
import 'package:vendor/models/product.dart';
import 'package:flutter/foundation.dart';

class EditProductDetailScreen extends StatefulWidget {
  final Product product;

  const EditProductDetailScreen({super.key,required this.product});

  @override
  State<EditProductDetailScreen> createState() => _EditProductDetailScreenState();
}

class _EditProductDetailScreenState extends State<EditProductDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late TextEditingController productNameController;
  late TextEditingController productPriceController; 
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  List<XFile>? pickedImages;
  

   @override 
   void initState(){
    super.initState();
    productNameController = 
             TextEditingController(text: widget.product.productName);
    productPriceController = 
             TextEditingController(text: widget.product.productPrice.toString());
    quantityController = 
             TextEditingController(text: widget.product.quantity.toString());
    descriptionController = 
             TextEditingController(text: widget.product.description);
       
   }

   Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    setState(() {
      pickedImages = pickedFiles;
    });
   }

   Future<void> _updateProduct() async {
    if(_formKey.currentState!.validate()){

      //upload images if selected

       // Convert XFiles to Files
    List<File>? imageFiles = pickedImages?.map((xfile) => File(xfile.path)).toList();
    
    List<String> uploadedImages = imageFiles != null && imageFiles.isNotEmpty
      ? await _productController.uploadImageToCloudinary(imageFiles, widget.product)
      : widget.product.images;


      // create an instance of the product model object


      final updateProduct = Product(
        id: widget.product.id, 
        productName: productNameController.text, 
        productPrice: int.parse(productPriceController.text), 
        quantity: int.parse(quantityController.text), 
        description: descriptionController.text, 
        category: widget.product.category, 
        vendorId: widget.product.vendorId, 
        fullName: widget.product.fullName, 
        subCategory: widget.product.subCategory, 
        images: uploadedImages
      );

      await _productController.updateProduct(
        product: updateProduct, 
        pickedImages: imageFiles, 
        context: context
      );
    } else {
      print('fill in all fields');
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                validator: (value) => 
                  value!.isEmpty? "Enter product name": null, 
                
                controller: productNameController,
                decoration: const InputDecoration(
                  labelText: 'product Name' 
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) => 
                  value!.isEmpty? "Enter product price": null, 
                
                controller: productPriceController,
                decoration: const InputDecoration(
                  labelText: 'product Price' 
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) => 
                  value!.isEmpty? "Enter product quantity": null, 
                
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'product quantity' 
                ),
              ),
              TextFormField(
                maxLength: 500,
                maxLines: 6,
                keyboardType: TextInputType.number,
                validator: (value) => 
                  value!.isEmpty? "Enter product description": null, 
                
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'product description' 
                ),
              ), 
              const SizedBox(height: 20,), 

              //Display the Current Product Images
              if(widget.product.images.isNotEmpty)
                Wrap(
                  spacing: 10, 
                  children: widget.product.images.map((imageUrl){
                    return InkWell(
                      onTap: (){
                        _pickImages();
                      },
                      child: Image.network(
                      imageUrl, 
                      width: 100,
                      height: 100,
                      ),
                      
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20,), 

                if(pickedImages!=null)
                Wrap(
                  spacing: 10, 
                  children: pickedImages!.map((image){
                    if (kIsWeb) {
                      return Image.network(
                        image.path,
                        width: 100,
                        height: 100,
                        );
                   } else {
                    return Image.file(
                    File(image.path), 
                    width: 100,
                    height: 100,
                    );
                  } 
                  }).toList(),
                ),
              
              ElevatedButton(
              onPressed: ()async{
                await _updateProduct();
              }, 
              child: Text('Update Product'))
            ],
          ),
        )
      ),
    );
  }
}
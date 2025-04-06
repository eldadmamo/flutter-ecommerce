import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:ecommerceflutter/controllers/product_review_controller.dart';
import 'package:ecommerceflutter/models/order.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();

  double rating = 0.0;

  final ProductReviewController _productReviewController = ProductReviewController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
        widget.order.productName,
        style: GoogleFonts.montserrat( 
          fontWeight: FontWeight.bold
        ),
        )
      ),
      body: Column(
        children: [
          Container( 
              width: 450, 
              height: 153, 
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none, 
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 450, 
                        height: 154,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0XFFEFF0F2),  
                          ),
                          borderRadius: BorderRadius.circular(9)
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 13, 
                              top: 9, 
                              child: Container(
                                width: 78, 
                                height: 78, 
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Color(0XFFBCC5FF),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 5, 
                                      child: Image.network(widget.order.image ,
                                      width: 58,
                                      height: 67,
                                      fit: BoxFit.cover,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ), 
                            Positioned(
                              left: 101,
                              top: 14,
                              child: SizedBox(
                                width: 216, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              widget.order.productName, 
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700, 
                                                fontSize: 16
                                              ),
                                            ),
                                          ), 
                                          SizedBox(height: 4),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(widget.order.category,
                                            style: GoogleFonts.montserrat(
                                              color: const Color(0XFF7F808c),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12
                                            ),
                                            ),
                                          ),
            
                                          const SizedBox(height: 2,), 
                                            Text(
                                              "\$${widget.order.productPrice.toStringAsFixed(2)}",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF080C1E)
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 13, 
                              top: 113, 
                              child: Container(
                                width: 90, 
                                height: 25, 
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: widget.order.delivered==true
                                 ? const Color(0XFF3C55EF):
                                 widget.order.processing == true ? Colors.purple: Colors.red,
                                 borderRadius: BorderRadius.circular(4), 
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 9, 
                                      top: 2,
                                      child: Text(
                                        widget.order.delivered==true? "Delivered": widget.order.processing==true? "Processing": "Cancelled", 
            
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          
                                          fontWeight: FontWeight.bold, 
                                          letterSpacing: 1.3 
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              )
                            ), 
                            Positioned(
                              top: 115,
                              left: 400, 
                              child: InkWell(
                                onTap: (){},
                                child: Image.asset('assets/icons/delete.png', 
                                width: 20, 
                                height: 20, 
                                ),
                              )
                            )
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              child: Container(
                width: 450, 
                height: widget.order.delivered==true? 170:120, 
                decoration: BoxDecoration(
                  color: Colors.white, 
                  border: Border.all(
                    color: const Color(
                      0XFFEFF0F2
                      ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Padding(padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery Address', style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1.7
                        ),
                        ),
                       const SizedBox(height: 8,), 
                       Text("${widget.order.state} ${widget.order.city} ${widget.order.locality}", 
                         style: GoogleFonts.lato(
                          fontSize: 17,
                          letterSpacing: 1.5, 
                          fontWeight: FontWeight.w900
                         ),
                       ),
                       Text("to ${widget.order.fullName}", 
                       style: GoogleFonts.lato( 
                        fontSize: 17,
                        fontWeight: FontWeight.bold, 
                       ),
                       ),
                       Text(
                        "Order Id: ${widget.order.id}", 
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold
                        ),
                       ),
                      ],
                    ),
                    ),
               widget.order.delivered==true ? TextButton(
                onPressed: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: Text('Leave a review'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _reviewController,
                            decoration: InputDecoration(
                              labelText: 'Your Review'
                            ),
                          ),
                          RatingBar(
                            filledIcon: Icons.star, 
                            emptyIcon: Icons.star_border, 
                            onRatingChanged: (value) {
                              rating = value;
                            },
                            initialRating: 3,
                            maxRating: 5,
                          ), 
                        ],
                      ),
                      actions: [
                        TextButton(
                        onPressed: (){
                          final review = _reviewController.text;

                          _productReviewController.uploadReview(
                            id: id, 
                            buyerId: widget.order.buyerId, 
                            email: widget.order.email, 
                            fullName: widget.order.fullName, 
                            productId: widget.order.id, 
                            rating: rating, 
                            review: review, 
                            context: context
                          );
                        }, 
                        child: const Text(
                          'Submit'
                        )
                        )
                      ],
                    );
                  });
                }, child: Text('Leave a review', 
               style: GoogleFonts.montserrat( 
                  fontSize: 12, 
                  fontWeight: FontWeight.bold
                  ),
                ) 
                ): SizedBox()
                  ],
                ),
              ),  
            ),

            
        ],
      ),
    );
  }
}
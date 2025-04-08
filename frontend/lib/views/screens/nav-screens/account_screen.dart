import 'package:ecommerceflutter/controllers/auth_controller.dart';
import 'package:ecommerceflutter/views/screens/detail/screens/order_screen.dart';
import 'package:ecommerceflutter/views/screens/nav-screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final AuthController _authController = AuthController();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 450, 
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/FBrbGWQJqIbpA5ZHEpajYAEh1V93%2Fuploads%2Fimages%2F78dbff80_1dfe_1db2_8fe9_13f5839e17c1_bg2.png?alt=media", 
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover, 
                    ),
                  ),
                  Positioned(
                    top: 30, 
                    right: 30, 
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        "assets/icons/not.png", 
                      width: 30, 
                      height: 30, 
                      ),
                    ),
                  ), 
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment(0, -0.53),
                        child: CircleAvatar(
                          radius: 65, 
                          backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png'),
                        ),
                      ),
                      Align(
                        alignment:const Alignment(0.23, -0.61),
                        child: InkWell(
                          onTap: (){},
                          child: Image.asset(
                            'assets/icons/edit.png' ,
                            width: 19, 
                            height: 19, 
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ), 
                  Align(
                    alignment: const Alignment(0, 0.03),
                    child: Text('Eldad Mamo', 
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    ),),
                  ), 
                  Align(
                    alignment: const Alignment(0.05, 0.17),
                    child: InkWell(
                      onTap: (){}, 
                      child: Text(
                        'Ethiopia', 
                        style: GoogleFonts.montserrat(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7 
                        ),
                      ),                   
                    ),
                  ), 
                  Align(
                    alignment: const Alignment(0.09, 0.81),
                    child: SizedBox(
                      width: 287, 
                      height: 117, 
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 66, 
                            left: 240,
                            child: Text("15" , 
                            style: GoogleFonts.roboto(
                              color: Colors.white, 
                              fontSize: 22 , 
                              letterSpacing: 0.4
                            ),
                            )
                          ), 
                          Positioned(
                            left: 212,
                            top: 99, 
                            child: Text(
                              "Completed", 
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.white, 
                              letterSpacing: 0.3
                            ),
                            )
                          ), 
                          Positioned(
                            left: 224, 
                            top: 2, 
                            child: Container(
                              width: 52, 
                              height: 58, 
                              clipBehavior: Clip.antiAlias,
                              decoration:const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png", 
                                  
                                  ),
                                  fit: BoxFit.contain
                                )
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 13, 
                                    top: 18, 
                                    child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F4ad2eb1752466c61c6bb41a0e223251a906a1a7bcorrect%201.png?alt=media&token=57abd4a6-50b4-4609-bb59-b48dce4c8cc6", 
                                      width: 26,
                                      height: 26, 
                                    )
                                  )
                                ],
                              ),
                            )
                          ),
                          Positioned(
                            left: 130,
                            top: 66,  
                            child: Text(
                              '5', 
                            style: GoogleFonts.montserrat(
                              color: Colors.white, 
                              fontSize: 22, 
                              letterSpacing: 0.4
                            ),
                           ),
                          ),
                          Positioned(
                            left: 108, 
                            top: 99, 
                            child: Text('Favorite', 
                            style: GoogleFonts.montserrat(
                              color: Colors.white, 
                              letterSpacing: 0.3, 
                            ),
                           ) 
                          ), 
                          Positioned(
                            left: 114, 
                            top: 2, 
                            child: Container(
                              width: 52, 
                              height: 58, 
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(

                                    "https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Ff0db1e22e37c1e2a001bbb5bd4b9aafc.png"
                                  ), 
                                ),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 15, 
                                    top: 18,
                                    child: Image.network(
                                      width: 26, 
                                      height: 26,
                                      "https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F068bdad59a9aff5a9ee67737678b8d5438866afewish-list%201.png?alt=media&token=4a8abc27-022f-4a53-8f07-8c10791468e4"
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20, 
                            top: 66, 
                            child: Text(
                              "20", 
                            style: GoogleFonts.montserrat(
                              color: Colors.white, 
                              fontSize: 22,
                              letterSpacing: 0.4
                            ),
                            )
                          ),
                          Positioned(
                            left: 13, 
                            top: 99, 
                            child: Text('Cart', 
                            style: GoogleFonts.montserrat(
                              fontSize: 14, 
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4
                            ),
                            ),
                          ), 
                          Positioned(
                            left: 5, 
                            top: 0, 
                            child: Container(
                              width: 56, 
                              height: 63, 
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage('https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fe0080f58f1ec1f2200fcf329b10ce4c4.png')
                                )
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 12, 
                                    top: 15, 
                                    child: Image.network(
                                      width: 33, 
                                      height: 33,
                                      'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2Fc2afb7fb33cd20f4f1aed312669aa43b8bb2d431cart%20(2)%201.png?alt=media&token=be3d8494-1ccd-4925-91f1-ee30402dfb0e')
                                  )
                                ],
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ), 
            ),
            
            ListTile(
              onTap: (){},
              leading: Image.asset(
                'assets/icons/orders.png',
              ),
              title: Text(
              'Track your order', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            const SizedBox(height: 10,), 
            ListTile(
              onTap: (){},
              leading: Image.asset(
                'assets/icons/history.png',
              ),
              title: Text(
              'History', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){},
              leading: Image.asset(
                'assets/icons/help.png',
              ),
              title: Text(
              'Help', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
               ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: (){},
              leading: Image.asset(
                'assets/icons/logout.png',
              ),
              title: Text(
              'Logout', 
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
               ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
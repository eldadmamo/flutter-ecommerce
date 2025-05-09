import 'package:admin/controllers/category_controller.dart';
import 'package:admin/models/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {

  late Future<List<Categorys>> futureCategories;
  @override
  void initState(){
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: futureCategories,
     builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(
          child: CircularProgressIndicator()
        );
      } else if (snapshot.hasError){
        return Center(
          child :Text('Error ${snapshot.error}')
        );
      } else if(!snapshot.hasData || snapshot.data!.isEmpty){
        return Center(child: Text('No Categories'));
      } else {
      final categories = snapshot.data!;
      return GridView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8
        ),
        itemBuilder: (context, index){
          final category = categories[index];
          return Column(
            children: [
              Image.network(category.image, height: 100, width: 100),
              Text(category.name)
            ],
          );
        },
        );
     }
     } 
     );
  }
}
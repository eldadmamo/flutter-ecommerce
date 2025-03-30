import 'package:admin/controllers/category_controller.dart';
import 'package:admin/models/category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = 'subCategoryScreen';

  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
 
  late Future<List<Categorys>> futureCategories;
  late String name;
  Categorys? selectedCategory; 
  dynamic _image;
  @override
  void initState(){
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  pickImage() async{
   FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false 
    );

    if (result!= null){
      setState(() {
        _image = result.files.first.bytes;
      });
    }
   }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text('SubCategories', 
                  style: TextStyle(
                    fontSize: 36, 
                    fontWeight: FontWeight.bold
                    ),
                    ),
                ),
              ),
           Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.grey
                ),
            ),
           FutureBuilder(
                future: futureCategories, 
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError){
                    return Center(child: Text('Error: ${snapshot.error}'),);
                  } else if (snapshot.hasData && snapshot.data!.isEmpty){
                    return const Center(child: Text('No Categories'),);
                  } else {
                    return DropdownButton<Categorys>(
                      hint: const Text('Select Category'),
                      items: snapshot.data!.map((Categorys category){
                        return DropdownMenuItem(
                          value: category, 
                          child: Text(category.name));
                      }).toList(), 
                      onChanged: (value){
                        setState(() {
                          selectedCategory = value;
                        });
                        print(selectedCategory!.name);
                      }
                  );
                  }
            }),
            Row(
                children: [
                  Container(
                    width: 150, 
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5,), 
                    ),
                    child: Center(
                      child: _image != null
                      ? Image.memory(_image) 
                      : const Text('Subcategory image'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150, 
                      child: TextFormField(
                        onChanged: (value){
                          
                        },
                        validator: (value){
                          if(value!.isNotEmpty){
                            return null;
                          } else {
                            return 'Please enter subcategory name';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Enter SubCategory name'
                        )
                      ),
                    ),
                  ),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue
                    ),
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                          
                      }
                    }, child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white
                    ),
                    ),
                    ),
                ],
              ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (){
                   ();
                }, 
                child: Text("Pick Image")),
            ),
            Divider(
              color: Colors.black,
            ),
        ],
      ),
    );
  }
}
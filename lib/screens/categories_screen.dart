import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../utils/constants.dart';
import 'category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.nBlue,
        iconTheme: IconThemeData(color: Constants.nGrey),
        title: Text('Categories' ,style: TextStyle(color: Constants.nGrey , fontWeight: FontWeight.bold),),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [

              Container(
                padding: EdgeInsets.symmetric(vertical: 30 , horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Constants.nBlue,
                      Constants.nBlue.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.nGrey,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.nCharcoal.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Constants.nBlue,
                          size: 24,
                        ),
                        // onPressed: _onSearchPressed,
                        onPressed: ()=>{},
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[400],
                        ),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onChanged: categoryProvider.searchCategories,
                  ),
                ),
              )
              ,



              Expanded(
                child: ListView.builder(
                  itemCount: categoryProvider.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.filteredCategories[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(category.displayName , style: TextStyle( color: Constants.nCharcoal),),
                        trailing: Icon(Icons.arrow_forward_ios , color: Constants.nBlue,),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                category: category.name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
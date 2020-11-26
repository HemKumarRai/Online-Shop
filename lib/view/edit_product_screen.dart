import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/modal/product.dart';
import 'package:online_shop/modal/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routName = "/edit_product_screen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _isInit = true;
  final formKey = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final imgUrlController = new TextEditingController();
  bool isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageUrl: "",
//    isFavourite: false,
  );

  var initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();
    _imgUrlFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = formKey.currentState.validate();
    if (isValid) {
      formKey.currentState.save();
      Navigator.pop(context);
    }
    if (!isValid) {
      return;
    }
    formKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedProduct.id != null) {
      try {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (e) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error Occured"),
                  content: Text("Something occured Product could not added"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error Occured"),
                  content: Text("Something has occured be added"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      }
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String id = ModalRoute.of(context).settings.arguments;
      if (id != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(id);

        initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.imageUrl,
        };
        imgUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id != null
            ? Text("Edit Product")
            : Text("Add Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
            ),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValues['title'],
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Title must be Include";
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: val.trimLeft().trim(),
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      initialValue: initValues['rice'],
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Price Must be Include";
                        }
                        if (double.tryParse(val) == null) {
                          return "The Price must be in Number";
                        }
                        if (double.parse(val) <= 0) {
                          return "The Price Shouldnot be Less Then Zero";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.tryParse(val),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      validator: (val) {
                        if (val.isEmpty) {
                          return "The description must not be empty";
                        }
                        if (val.length < 10) {
                          return 'Description must contain atleast 10 letter';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: val.trim(),
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imgUrlFocusNode);
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                    ),
                    Row(
                      children: <Widget>[
                        imgUrlController.text.isEmpty
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Container(
                                    child: Center(child: Text("ImageUrl")),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueGrey, width: 1)),
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: FittedBox(
                                  child: Image.network(imgUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'The image url must not be empty!';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'The image url is not valid!';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg') &&
                                  !value.endsWith('.JPG')) {
                                return 'The image url is not correct!';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: val.trim(),
                              );
                            },
                            controller: imgUrlController,
                            decoration: InputDecoration(
                              labelText: "Enter a Url",
                            ),
                            focusNode: _imgUrlFocusNode,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    imgUrlController.dispose();
    super.dispose();
  }
}

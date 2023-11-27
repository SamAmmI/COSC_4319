/*import 'package:flutter/material.dart';

class Recipe {
  String title;
  List<String> ingredients;

  Recipe({required this.title, required this.ingredients});
}

class SavedRecipes extends StatefulWidget {
  @override
  _SavedRecipesState createState() => _SavedRecipesState();
}

class _SavedRecipesState extends State<SavedRecipes> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeIngredients(recipe: recipes[index])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipe()),
          ).then((newRecipe) {
            if (newRecipe != null) {
              setState(() {
                recipes.add(newRecipe);
              });
            }
          });
        },
      ),
    );
  }
}

class RecipeIngredients extends StatelessWidget {
  final Recipe recipe;

  RecipeIngredients({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Ingredients'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text(
            recipe.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ...recipe.ingredients.map((ingredient) => Text('• $ingredient')).toList(),
          ElevatedButton(
            child: Text('Edit Recipe'),
            onPressed: () {
              // Implement your function here
            },
          ),
          ElevatedButton(
            child: Text('Delete Recipe'),
            onPressed: () {
              // Implement your function here
            },
          ),
        ],
      ),
    );
  }
}

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final titleController = TextEditingController();
  final ingredientsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Recipe Title',
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: ingredientsController,
            decoration: InputDecoration(
              labelText: 'Ingredients (comma separated)',
            ),
          ),
          ElevatedButton(
            child: Text('Save Recipe'),
            onPressed: () {
              Navigator.pop(
                context,
                Recipe(
                  title: titleController.text,
                  ingredients: ingredientsController.text.split(',').map((ingredient) => ingredient.trim()).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
*/
input = 580741

recipes = "37"
i = 0
j = 1
strInput = str(input)
while not strInput in recipes[-7:]:
    recipe1 = int(recipes[i])
    recipe2 = int(recipes[j])
    recipes += str(recipe1 + recipe2)
    i = (i + recipe1 + 1) % len(recipes)
    j = (j + recipe2 + 1) % len(recipes)
print recipes.find(strInput)

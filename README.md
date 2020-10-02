# Bookmarking Terminal App

## GitHub

Github repo location

## Installation and Setup

1. Install ruby, we recommend using [asdf](https://asdf-vm.com/)

2. Install [git](https://git-scm.com/downloads)

3. `git clone` the app to your home directory

```bash
git clone githubrepo_nameRecipes_app.git ~/Recipes_app
```

4. Run the `setup` executable file

```bash
~/Recipes_app/bin/setup
```

5. Open your `.bash_profile` in a text editor

6. Add this line

```bash
export PATH=$PATH:$HOME/Recipes_app/bin
```

7. Restart your terminal to make sure `.bash_profile` loads the app into your PATH

8. Run the `Recipes_app` executable to start the app

```bash
Recipes_app
```

## Software Development Plan

## Features

## Outline of User Interaction

- The user can learn about how to interact with the app by passing either '-h' or '-help' as an argv input 
- They can also see all the available functions of the app via the menu, the menu is using the tty-prompt gem to ensure it's legible and much easier to use instead of just taking in raw user input
- Error are handled with control flow
  - An example of error handling is, should the user attempt to write their own recipe but miss any of the input fields the app simply returns them to the main menu and prompts them to enter something for each input rather than allowing them to enter a nill field which results in a blank string and in some cases breaks the apps interface of displaying data 


## Project Management

I used Trello to manage the different tasks that needed to be done.

Here is a link to [my board](https://trello.com/b/vckpMdRt/recipes-app).

## Diagram
![sitemap-image](docs/sitemap.png)


## Tests

Here is a link to my [testing spreadsheet]().

If you use RSpec you can say...

To run tests run:

```bash
rspec spec
```
# Csode Dotfiles

<center><img style="width: 200px" src="docs/img/logo.png" alt="logo"/></center>

## Quick Preview Of Script

<div style="text-align: center;">
  <img src="./docs/demo.gif" alt="Demo GIF" style="max-width: 100%; height: auto;" />
</div>

This is a full system managment of packages and dotfiles inspired by nix on how to make Arch-based distro more stable and more configurable. I moved to wayland and I have got majority of the things up and running I have made it so that you can choose between what you want to use. Either hyprland or i3 or both if you want note it will be finiky when you are using both of them at the same time.

> [!NOTE]
> It is better to use one of the Desktop enviroment provided than to use both at the exact same time.

> [!NOTE]
> This is just a personal preference meaning it is not for meant for everybody who just want their things to work.

> [!WARNING]
> All of the tools I use here are my choices so be aware that you have to do your own setup.  And this will only work for archlinux at the moment. Be ware that this is not distro compatible.

## Introduction
This is a custom enviroment I setup for archlinux on a better use of my system. This is a customized script to automate my linux setup and make my life easier. Also it includes my custom desktop enviroment as of this moment it is hyprland. I am giving wayland a chance now. As a side not be ware I still love X11 but it is dying and it is time to move on.

## Philosophy 
The philosophy behind this system configuration is I want to have a much more modular OS and a better package managment. I have been inspired by many projects while making this project. What I want from my system is something that just works without it being a hasself for me to setup which it is not. 
> [!NOTE]
> This is still a work in progress now since I moved to wayland. I still am going to choose some tooling here and there and see for myself what I like and don't like. If you guys have suggesstions please do let me know. And I am changing some of the things I used to do and hence for I am making adjustments here and there.

## Inspirations
As I mentioned earlier there are lots of projects that I took inspiration from and below I have listed all the things that inspired me while making this. And I should give mad props to them.

[Linux Cast](https://gitlab.com/thelinuxcast/my-dots): Hyprland, rofi and waybar config is mostly inspired by his configuration. I modified it to make it work for me.

[Nix](https://nixos.org/): Inspiration came from making a packages.json to manage my packages so that it is modular.

[Kickstart-nvim](https://github.com/nvim-lua/kickstart.nvim.git): It was my starting point when I first started learning neovim

[DT-Emacs](https://gitlab.com/dwt1/dotfiles/-/tree/master/.config/emacs): A better emacs configuration I saw from my previous one.

## Managment 
How I manage all of my things is through symbolic links and also through my own package managment system. From the script you have seen me install a few things here and there. The scripts operates like what nix is doind except it does not lock packages and it does not have a further configuration system like flakes or anything of that sort. I define all of my packages in my packages.json then when I install a new instance of arch I can use that package.json to get all of my packages so instead of being like oh what did I call it or things of that sort. I know what you  guys will say use Nixos in that case. NO!! I don't want to use Nixos it is not what I would consider a trandition linux distro on other things. I want a machine that works and does not require me to learn a new language for that. Am I being lazy?? Sure but here I do not care anymore.
For the rest of the stuff I go add all of my configuration files in my dotfiles then symlink them. Everytime I add a new config I have to reset it which sucks and I am planning to fix that pretty soon.

## Main setup

- *Wayland Setup*
- *WM* : Hyprland
- *App launcher* : rofi-wayland
- *Text editor* : Emacs
- *Bar* : Waybar
- *Wallpaper utility* : swww
- *Color scheme* : gruvbox

## Instrcution 

To replicate my whole system it is easy to do. Follow the instrcution.

> [!WARNING]
> This will install some things like jq and dialog if they are not installed.

1. Clone the repository
```
git clone https://github.com/xsoder/env.git ~/devenv 
```

2. Change the directory
```
cd ~/devenv
```

3. Simply run
```
bash script
```

If you want more information on each of the files and more. Each directory has a readme. Go follow those.

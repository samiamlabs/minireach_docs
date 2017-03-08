Building New Releases
---------------------

Install prerequisites:

```
sudo apt install pip
sudo pip install sphinx
sudo pip install sphinx_rtd_theme
```

```
make html
make latexpdf
```

Troubleshooting:

If you get complaints about .sty files install the following

```
sudo apt-get install texlive-full
```
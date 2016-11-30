Building New Releases
---------------------

Install prerequisites:

```
sudo pip install sphinx
```

```
make html
make latexpdf
git push origin gh-pages
```

Troubleshooting:

If you get complaints about .sty files install the following

```
sudo apt-get install texlive-full
```
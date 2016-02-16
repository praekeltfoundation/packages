# Adding a new package

Sign the package using the packman gpg key

`dpkg-sig --sign builder foo_0.1.1_amd64.deb`

Then add the package with reprepro

```
cd ubuntu
reprepro includedeb trusty ../foo_0.1.1_all.deb
```

Add everything in the pool

`git add pool/`

And commit the package

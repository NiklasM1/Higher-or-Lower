# Higher-or-Lower

Simple Higher or Lower game. Has three modes, Searches (on Google), Views (on YouTube) and Price (on Amazon and other Sides).

## Api Usage

Expects Json input in the form of:
```javascript
{
  "type": x (String),
  "id"  : y (Int)
}
```

where x is the type of product you wanna get the Items from (either Search, Price, Views). And y ist the Items id in the Database. If y is 0, it will return the count of elements from that type:
```javascript
{
  "COUNT(*)" = y (Int)
}
```
Otherwise it will return the coresponding Item:

```javascript
{
  "id"      : x (Int), 
  "name"    : y (String),
  "value"   : z (Double),
  "picture" : u (String),
  "source"  : w (String)
}
```

![Screenshot 2022-05-12 123347](https://user-images.githubusercontent.com/61799454/168051793-88227925-39c1-4bde-8fa5-09397d5d7ff6.png)

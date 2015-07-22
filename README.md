# smartprop
Smart and effortless json data search in JavaScript

## Description
Smartprop is used for searching a value assigned to a key in a complicated nested object.

## Examples

### SmartProp
```javascript
var SmarProp = require("smartprop").SmartProp
var SmartObject = require("smartprop").SmartObject
data = {
  item : {
    owner : {
      id : 1,
      profile : {
        name: "Chris"
        reputation : 10
        his_site_url : "www.site.com"
      }
    }
    price: 10 
  }
}
var name = new SmartProp("name")
name.findIn(data)   #=> "Chris"

var price = new SmartProp("price")
price.findIn(data)  #=> 10

var site = new SmartProp(/site/)
site.findIn(data)   #=> "www.site.com"
```
### SmartObject
```javascript
var smartobject = new SmartObject({name : "name", price: "price", website: /site/})
smartobject.map(data)    #=> {name : "Chris, price: 10, website: www.site.com"}
```


## Step 1 — Test MongoDB directly
#### Download/install the Windows version of MongoDB Server and Shell from the official MongoDB site:
- [MongoDB Server (mongod) download](https://www.mongodb.com/try/download/community)
- [MongoDB Shell (mongosh) download](https://www.mongodb.com/try/download/shell)

#### Choose: `Platform: Windows` and `Package: MSI`

#### Install it with the default options.

### Testing Installations
#### Check the MongoDB installation:
- `where.exe mongod` or `where.exe mongosh`
- `Get-ChildItem "C:\Program Files\MongoDB" -Recurse -Filter "mongod.exe" -ErrorAction SilentlyContinue`
- Test MongoDB directly from the path: `& "C:\Program Files\MongoDB\Server\8.3\bin\mongod.exe" --version`
#### Add MongoDB to PATH
- Open PowerShell as Administrator and run:
 ```
  [Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\Program Files\MongoDB\Server\8.3\bin",
    "Machine"
)
  ```
- You should now get the MongoDB version by running: `mongod --version` and `mongosh --version`
- Also Check whether MongoDB is running as a Windows service: `Get-Service MongoDB`

#### Verify the server is accepting connections
Even without  `mongosh`, you can check that MongoDB is listening on the default port:
`Test-NetConnection localhost -Port 27017`
- Look for:`TcpTestSucceeded : True`. If it says `True`, your MongoDB server is ready.

#### Connect to MongoDB
- Run: `mongosh`
- You should see something similar to:
```
Current Mongosh Log ID: ...
Connecting to: mongodb://127.0.0.1:27017/
Using MongoDB: 8.3.8
Using Mongosh: 2.x.x
```
- Then you'll get: `test> ` That means MongoDB is fully operational.
- Try: `show dbs` and `show collections`

### Test creating a database

- Inside `mongosh`, run: `use myFirstDB`. You will see a message like: `switched to db myFirstDB
myFirstDB>`
- Then to add an entry to a collection of `myFirstDB`:
```
db.firstcollection.insertOne({
    name: "Laptop",
    price: 50000,
    category: "Electronics"
})
```
- You should receive something like:
```
{
  acknowledged: true,
  insertedId: ObjectId('...')
}
```
-  `db.firstcollection.find().find()` will show the product in the collection.
- Now add three items to `products` collection:
```
db.products.insertMany([
    {
        name: "Mouse",
        price: 800,
        category: "Accessories",
        stock: 50
    },
    {
        name: "Keyboard",
        price: 1500,
        category: "Accessories",
        stock: 30
    },
    {
        name: "Monitor",
        price: 15000,
        category: "Electronics",
        stock: 15
    }
])
```
- 
- Similarly, Insert a few documents into the `sales` collection.
```
db.getCollection('sales').insertMany([
  { 'item': 'abc', 'price': 10, 'quantity': 2, 'date': new Date('2014-03-01T08:00:00Z') },
  { 'item': 'jkl', 'price': 20, 'quantity': 1, 'date': new Date('2014-03-01T09:00:00Z') },
  { 'item': 'xyz', 'price': 5, 'quantity': 10, 'date': new Date('2014-03-15T09:00:00Z') },
  { 'item': 'xyz', 'price': 5, 'quantity': 20, 'date': new Date('2014-04-04T11:21:39.736Z') },
  { 'item': 'abc', 'price': 10, 'quantity': 10, 'date': new Date('2014-04-04T21:23:13.331Z') },
  { 'item': 'def', 'price': 7.5, 'quantity': 5, 'date': new Date('2015-06-04T05:08:13Z') },
  { 'item': 'def', 'price': 7.5, 'quantity': 10, 'date': new Date('2015-09-10T08:43:00Z') },
  { 'item': 'abc', 'price': 10, 'quantity': 5, 'date': new Date('2016-02-06T20:20:13Z') },
]);
```

- Now You can see the collections in your database with:`show collections` and their strength by: `db.products.countDocuments()`
-  Drop all the  existing collections from the DB by: `db.dropDatabase();`

### A complete CRUD example
- CREATE:
```
db.products.insertOne({
    name: "Phone",
    price: 30000,
    category: "Electronics",
    stock: 20
})
```
- READ:
```
db.products.findOne({
    name: "Phone"
})
```
- UPDATE:
```
db.products.updateOne(
    { name: "Phone" },
    { $set: { price: 28000 } }
)
```
Check: `db.products.findOne({  name: "Phone"})`

- DELETE: `db.products.deleteOne({ name: "Phone"})`
Verify: `db.products.findOne({ name: "Phone"})`

### Some More Operations using  CRUD
#### 1. CREATE — Insert documents
- Insert one document: ``` db.products.insertOne({
    name: "Laptop",
    price: 50000,
    category: "Electronics",
    stock: 10
})```
#### 2. READ — Find documents
Now let's retrieve the data.
- Show everything: `db.products.find()`
- For easier reading: `db.products.find().pretty()`
- Find one specific product: `db.products.findOne({
    name: "Laptop"
})`
- Find products by category: `db.products.find({
    category: "Electronics"
})`
- Find products by price: `db.products.find({
    price: { $gt: 10000 }
})`
- Some other useful operators:
  
|Operator|	Meaning|
| :------: | :------- |
|$gt	|greater than|
|$gte	|greater than or equal|
|$lt	|less than|
|$lte	|less than or equal|
|$eq	|equal|
|$ne	|not equal|
|$in	|matches one of several values|
#### 3. UPDATE — Modify documents
Now let's change some data.
- Suppose the laptop price changes from ₹50,000 to ₹55,000.
```
db.products.updateOne(
    { name: "Laptop" },
    { $set: { price: 55000 } }
)
```
- You should get:
```
{
  acknowledged: true,
  matchedCount: 1,
  modifiedCount: 1
}
```
- Check: `db.products.findOne({ name: "Laptop" })`
  
Update multiple documents
- Suppose you want to add a brand field to all accessories:
```
db.products.updateMany(
    { category: "Accessories" },
    { $set: { brand: "Generic" } }
)
```
- Check: `db.products.find({
    category: "Accessories"
})`
Increase a numeric value
Suppose you receive 20 additional laptops.
Instead of replacing the stock value, use `$inc`:
```
db.products.updateOne(
    { name: "Laptop" },
    { $inc: { stock: 20 } }
)
```
- Check: `db.products.findOne({ name: "Laptop" })`
  
#### 4. DELETE — Remove documents
Be careful with delete operations.
-  Suppose we don't want the Monitor anymore: `db.products.deleteOne({
    name: "Monitor"
})`
-  You'll get: `{
  acknowledged: true,
  deletedCount: 1
}`
- Verify: `db.products.find()`. The Monitor should be gone.
  
Delete multiple documents
- Suppose we want to remove all products in the Accessories category:` db.products.deleteMany({
    category: "Accessories"
})`
- Then: `db.products.find()` . The Mouse and Keyboard will be gone.
- 





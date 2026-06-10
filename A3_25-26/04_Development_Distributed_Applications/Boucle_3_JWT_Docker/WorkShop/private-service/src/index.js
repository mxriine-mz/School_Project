const express = require('express');
const app = express();
const port = 3000;

app.get('/api/', function(req, res) {
  res.status(200).json({msg : "Welcome on private service"});
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

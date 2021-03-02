const fetch = require("node-fetch");
const express=require('express');
const app= express();

app.set('view engine', 'ejs');
app.set('views', './views');
app.use(express.static('./assests'));


var result = [];
fetch("https://api.wazirx.com/api/v2/tickers",{
    
})
.then(res => res.json())
    .then(json => {
        var data = json;
            JSON.stringify(data);
            var x = 1;    
            for(let i in data){
                result[x] = data[i];
                if(x==10)
                {
                    break;
                }
                x++;
            }
})

app.get('/',function(req,res){
    return res.render('index',{
        title:"QuadB",
        Result : result
    })
});

app.listen(8080);
console.log("listening 8080");
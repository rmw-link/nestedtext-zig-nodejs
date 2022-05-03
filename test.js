const {
  nt2json
} = require('./lib.node');
console.log(nt2json("1: 2"))
try {
  console.log(nt2json("1"))
} catch (err) {
  console.log("!!!!", err)
}

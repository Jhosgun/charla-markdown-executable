// BUG real del issue #42: no suma shipping.
function total(items, shipping) {
  return items.reduce((s, i) => s + i.price, 0); // falta + shipping
}
module.exports = { total };

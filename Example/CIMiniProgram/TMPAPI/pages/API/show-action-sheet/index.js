const data = {
  el: '#page',
  methods: {
  showActionSheet() {
    Bridge.showActionSheet({
      itemList: ['item1', 'item2', 'item3', 'item4'],
      success(e) {
        console.log(e.tapIndex)
      }
    })
  }
}}

const lifeCycle = ['onReady', 'onShow', 'onHide']

class Page {
  constructor(data) {
    this.vueIns = new Vue(data)
    lifeCycle.forEach(hook => {
      data[hook] && ( this[hook] = data[hook].bind(this.vueIns) )
    })
  }
}
const pageIns = new Page(data)
window.pageIns = pageIns

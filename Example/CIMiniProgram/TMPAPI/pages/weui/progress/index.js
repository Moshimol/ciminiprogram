const data = {
  el: '#page',
  data() {
  return {
    progress: 0,
    disabled: false
  }
},
methods: {
  upload(){
    if (this.disabled) {
      return
    }
    this.progress = 0
    this.disabled = true
    this._next()
  },
  _next(){
    var that = this;
    if (this.progress >= 100) {
      this.disabled = false
      return true;
    }
    this.progress = ++this.progress
    setTimeout(function () {
      that._next()
    }, 20)
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

const data = {
  el: '#page',
  data() {
  return {
    istrue: false
  }
},
methods: {
  openGallery() {
    this.istrue = true
  },
  closeGallery() {
    this.istrue = false
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

const data = {
  el: '#page',
  data() {
  return {
    showDialog: false,
    istrue: false
  }
},
methods: {
  openDialog() {
    this.istrue = true
  },
  closeDialog() {
    this.istrue = false
  }
}
}

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

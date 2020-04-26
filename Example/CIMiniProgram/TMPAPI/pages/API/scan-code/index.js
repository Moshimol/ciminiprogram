const data = {
  el: '#page',
  data() {
  return {
    result: ''
  }
},
methods: {
  scanCode() {
    const that = this
    Bridge.scanCode({
      onlyFromCamera: false,
      scanType: ['barCode', 'qrCode'],
      success(res) {
        that.result = res.result
      },
      fail() {}
    })
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

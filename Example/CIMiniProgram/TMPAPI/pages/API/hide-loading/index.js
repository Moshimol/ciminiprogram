const data = {
  el: '#page',
  mounted() {
  Bridge.showLoading({
    title: '加载中',
    mask: 'red'
  })
},
methods: {
  hideLoading() {
    Bridge.hideLoading()
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

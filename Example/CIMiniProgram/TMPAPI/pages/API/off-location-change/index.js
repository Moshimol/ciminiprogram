const data = {
  el: '#page',
  created() {
  Bridge.startLocationUpdate()
  Bridge.onLocationChange((res) => {
    Bridge.showModal({
      content: JSON.stringify(res)
    })
  })
},
methods: {
  offLocationChange() {
    Bridge.offLocationChange((res) => {
      Bridge.showModal({
        content: JSON.stringify(res)
      })
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
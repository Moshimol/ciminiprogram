const data = {
  el: '#page',
  methods: {
  openSuccess() {
    Bridge.navigateTo({
      url: '/pages/weui/msg/msg_success'
    })
  },
  openText() {
    Bridge.navigateTo({
      url: '/pages/weui/msg/msg_text'
    })
  },
  openTextPrimary() {
    Bridge.navigateTo({
      url: '/pages/weui/msg/msg_text_primary'
    })
  },
  openFail() {
    Bridge.navigateTo({
      url: '/pages/weui/msg/msg_fail'
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

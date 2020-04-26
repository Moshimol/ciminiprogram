const data = {
  el: '#page',
  data() {
  return {
    content: [],
    index: 0,
    socketOpen: false
  }
},
methods: {
  wsSendMsg() {
    this.socketOpen && Bridge.sendSocketMessage({
      data: `${this.index++}`
    })
  },
  closeWebSocket() {
    this.socketOpen && Bridge.closeSocket()
    this.socketOpen = false
  }
},
created() {
  Bridge.connectSocket({
    url: 'ws://211.159.154.159/ws/'
  })

  Bridge.onSocketOpen((res) => {
    this.socketOpen = true
    this.content.push('Open')
  })
  Bridge.onSocketMessage((res) => {
    this.content.push(`Message: ${res.data}`)
  })
  Bridge.onSocketClose((msg) => {
    this.content.push('Close')
  })
},
onHide() {
  this.closeWebSocket()
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

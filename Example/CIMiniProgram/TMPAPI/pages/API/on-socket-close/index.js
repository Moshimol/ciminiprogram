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
  connectWebSocket() {
    Bridge.connectSocket({
      url: 'ws://211.159.154.159/ws/'
    })
  
    Bridge.onSocketOpen((res) => {
      this.socketOpen = true
      this.content.push('连接已打开')
    })
    Bridge.onSocketMessage((res) => {
      this.content.push(`收到消息: ${res.data}`)
    })
    Bridge.onSocketClose((res) => {
      this.content.push('连接已关闭')
    })
    Bridge.onSocketError((res) => {
      this.content.push(`错误: ${res.errMsg}`)
    })
  },
  closeWebSocket() {
    this.socketOpen && Bridge.closeSocket()
    this.socketOpen = false
  }
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

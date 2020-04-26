const data = {
  el: '#page',
  data() {
  return {
    content: [],
    index: 0,
    socketOpen: false
  }
},
created() {
  this.connectWebSocket()
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
    Bridge.onSocketClose((msg) => {
      this.content.push('连接已关闭')
    })
    Bridge.onSocketError((msg) => {
      this.content.push(`发生错误: ${msg}`)
    })
  },
  wsSendMsg() {
    this.socketOpen && Bridge.sendSocketMessage({
      data: `${this.index++}`
    })
  },
  onSocketMessage() {
    Bridge.onSocketMessage((res) => {
      this.content.push(`收到消息: ${res.data}`)
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

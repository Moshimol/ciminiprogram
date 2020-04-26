const data = {
  el: '#page',
  data() {
  return {
    ws: null,
    content: [],
    index: 0,
    socketOpen: false
  }
},
methods: {
  wsSendMsg() {
    this.ws.send({
      data: this.index++
    })
  },
  closeWebSocket() {
    this.ws.close({
      code: 1000
    })
  },
  async connectSocket() {
    this.ws = await Bridge.connectSocket({
      url: 'ws://211.159.154.159/ws/',
    })
    this.ws.onOpen(() => {
      this.socketOpen = true
      this.content.push('连接已打开')
    })
    this.ws.onClose(() => {
      this.socketOpen = false
      this.content.push('连接已关闭')
    })
    this.ws.onError(() => {
      this.content.push('发生错误')
    })
    this.ws.onMessage((res) => {
      this.content.push(`收到消息: ${res.data}`)
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

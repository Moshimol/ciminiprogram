const data = {
  el: '#page',
  data() {
  return {
    imageSrc: '',
    uploadFileUrl: ''
  }
},
methods: {
  chooseImage() {
    const self = this

    Bridge.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album'],
      success(res) {
        console.log('chooseImage success, temp path is', res.tempFilePaths[0])

        const imageSrc = res.tempFilePaths[0]

        Bridge.uploadFile({
          url: uploadFileUrl,
          filePath: imageSrc,
          name: 'data',
          success(res) {
            console.log('uploadImage success, res is:', res)

            Bridge.showToast({
              title: '上传成功',
              icon: 'success',
              duration: 1000
            })

            self.imageSrc = imageSrc
          },
          fail({errMsg}) {
            console.log('uploadImage fail, errMsg is', errMsg)
          }
        })
      },

      fail({errMsg}) {
        console.log('chooseImage fail, err is', errMsg)
      }
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

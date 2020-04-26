const data = {
  el: '#page',
  data() {
  return {
    list: [
      // {
      //   id: 'api',
      //   name: '开放接口',
      //   open: false,
      //   pages: [
      //    /*  {
      //       zh: '登录',
      //       url: 'login/index'
      //     }, {
      //       zh: '获取用户信息',
      //       url: 'get-user-info/index'
      //     }, {
      //       zh: '发起支付',
      //       url: 'request-payment//index'
      //     }, {
      //       zh: '转发',
      //       url: 'share/index'
      //     }, {
      //       zh: '转发按钮',
      //       url: 'share-button/index'
      //     }, {
      //       zh: '客服消息',
      //       url: 'custom-message/index'
      //     }, {
      //       zh: '模板消息',
      //       url: 'template-message/index'
      //     }, {
      //       zh: '收货地址',
      //       url: 'choose-address/index'
      //     }, {
      //       zh: '获取发票抬头',
      //       url: 'choose-invoice-title/index'
      //     }, {
      //       zh: '生物认证',
      //       url: 'soter-authentication/index'
      //     }, {
      //       zh: '设置',
      //       url: 'setting/index'
      //     } */
      //   ]
      // },
      // {
      //   id: 'page',
      //   name: '界面',
      //   open: false,
      //   pages: [
      //     /* {
      //       zh: '设置界面标题',
      //       url: 'set-navigation-bar-title/index'
      //     }, {
      //       zh: '标题栏加载动画',
      //       url: 'navigation-bar-loading/index'
      //     }, {
      //       zh: '设置TabBar',
      //       url: 'set-tab-bar/index'
      //     }, {
      //       zh: '页面跳转',
      //       url: 'navigator/index'
      //     }, {
      //       zh: '下拉刷新',
      //       url: 'pull-down-refresh/index'
      //     }, {
      //       zh: '创建动画',
      //       url: 'animation/index'
      //     }, {
      //       zh: '创建绘画',
      //       url: 'canvas/index'
      //     }, {
      //       zh: '显示操作菜单',
      //       url: 'action-sheet/index'
      //     }, {
      //       zh: '显示模态弹窗',
      //       url: 'modal/index'
      //     }, {
      //       zh: '页面滚动',
      //       url: 'page-scroll/index'
      //     }, {
      //       zh: '显示消息提示框',
      //       url: 'toast/index'
      //     }, {
      //       zh: '获取WXML节点信息',
      //       url: 'get-wxml-node-info/index'
      //     }, {
      //       zh: 'WXML节点布局相交状态',
      //       url: 'intersection-observer/index'
      //     } */
      //   ]
      // },
      // {
      //   id: 'device',
      //   name: '设备',
      //   open: false,
      //   pages: [
      //     /* {
      //       zh: '获取手机网络状态',
      //       url: 'get-network-type/index'
      //     }, {
      //       zh: '监听手机网络变化',
      //       url: 'on-network-status-change/index'
      //     }, {
      //       zh: '获取手机系统信息',
      //       url: 'get-system-info/index'
      //     }, {
      //       zh: '监听重力感应数据',
      //       url: 'on-accelerometer-change/index'
      //     }, {
      //       zh: '监听罗盘数据',
      //       url: 'on-compass-change/index'
      //     }, {
      //       zh: '打电话',
      //       url: 'make-phone-call/index'
      //     }, {
      //       zh: '扫码',
      //       url: 'scan-code/index'
      //     }, {
      //       zh: '剪切板',
      //       url: 'clipboard-data/index'
      //     }, {
      //       zh: '蓝牙',
      //       url: 'bluetooth/index'
      //     }, {
      //       zh: 'iBeacon',
      //       url: 'ibeacon/index'
      //     }, {
      //       zh: '屏幕亮度',
      //       url: 'screen-brightness/index'
      //     }, {
      //       zh: '用户截屏事件',
      //       url: 'capture-screen/index'
      //     }, {
      //       zh: '振动',
      //       url: 'vibrate/index'
      //     }, {
      //       zh: '手机联系人',
      //       url: 'add-contact/index'
      //     }, {
      //       zh: 'Wi-Fi',
      //       url: 'wifi/index'
      //     } */
      //   ]
      // },
      // {
      //   id: 'network',
      //   name: '网络',
      //   open: false,
      //   pages: [
      //    /*  {
      //       zh: '发起一个请求',
      //       url: 'request/index'
      //     }, {
      //       zh: 'WebSocket',
      //       url: 'web-socket/index'
      //     }, {
      //       zh: '上传文件',
      //       url: 'upload-file/index'
      //     }, {
      //       zh: '下载文件',
      //       url: 'download-file/index'
      //     } */
      //   ]
      // },
      // {
      //   id: 'media',
      //   name: '媒体',
      //   open: false,
      //   pages: [
      //     /* {
      //       zh: '图片',
      //       url: 'image/index'
      //     }, {
      //       zh: '录音',
      //       url: 'voice/index'
      //     }, {
      //       zh: '背景音频',
      //       url: 'background-audio/index'
      //     }, {
      //       zh: '文件',
      //       url: 'file/index'
      //     }, {
      //       zh: '视频',
      //       url: 'video/index'
      //     }, {
      //       zh: '动态加载字体',
      //       url: 'load-font-face/index'
      //     } */
      //   ]
      // },
      // {
      //   id: 'location',
      //   name: '位置',
      //   open: false,
      //   pages: [
      //    /*  {
      //       zh: '获取当前位置',
      //       url: 'get-location/index'
      //     }, {
      //       zh: '使用原生地图查看位置',
      //       url: 'open-location/index'
      //     }, {
      //       zh: '使用原生地图选择位置',
      //       url: 'choose-location/index'
      //     } */
      //   ]
      // },
      // {
      //   id: 'storage',
      //   name: '数据',
      //   url: 'storage/index'
      // },
      /*       {
              id: 'worker',
              name: '多线程',
              url: 'worker/index'
            }, */
      {
        id: 'base-system_info',
        name: '基础-系统信息',
        open: false,
        pages: [
          {
            zh: '获取系统信息',
            url: 'get-system-info/index'
          },
          {
            zh: '同步获取系统信息',
            url: 'get-system-info-sync/index'
          }
        ]
      },
      {
        id: 'router',
        name: '路由',
        open: false,
        pages: [
          {
            zh: '关闭小程序',
            url: 'close-program/index'
          },
          {
            zh: '跳转到 tabBar 页面，并关闭其他所有非 tabBar 页面',
            url: 'switch-tab/index'
          },
          {
            zh: '关闭所有页面，打开到应用内的某个页面',
            url: 're-launch/index'
          },
          {
            zh: '关闭当前页面，跳转到应用内的某个页面',
            url: 'redirect-to/index'
          },
          {
            zh: '保留当前页面，跳转到应用内的某个页面',
            url: 'navigate-to/index'
          },
          {
            zh: '关闭当前页面，返回上一页面或多级页面。',
            url: 'navigate-back/index'
          }
        ]
      },
      {
        id: 'page-interaction',
        name: '界面-交互',
        open: false,
        pages: [
          {
            zh: '显示消息提示框',
            url: 'show-toast/index'
          },
          {
            zh: '显示模态对话框',
            url: 'show-modal/index'
          },
          {
            zh: '显示 loading 提示框',
            url: 'show-loading/index'
          },
          {
            zh: '显示操作菜单',
            url: 'show-action-sheet/index'
          },
          {
            zh: '隐藏消息提示框',
            url: 'hide-toast/index'
          },
          {
            zh: '隐藏 loading 提示框',
            url: 'hide-loading/index'
          }
        ]
      },
      {
        id: 'page-navigation_bar',
        name: '界面-导航栏',
        open: false,
        pages: [
          {
            zh: '在当前页面显示导航条加载动画',
            url: 'show-navigation-bar-loading/index'
          },
          {
            zh: '动态设置当前页面的标题',
            url: 'set-navigation-bar-title/index'
          },
          {
            zh: '设置页面导航条颜色',
            url: 'set-navigation-bar-color/index'
          },
          {
            zh: '在当前页面隐藏导航条加载动画',
            url: 'hide-navigation-bar-loading/index'
          },
          {
            zh: '隐藏返回首页按钮',
            url: 'hide-home-button/index'
          }
        ]
      },
      {
        id: 'page-background',
        name: '界面-背景',
        open: false,
        pages: [
          {
            zh: '动态设置下拉背景字体样式',
            url: 'set-background-text-color/index'
          },
          {
            zh: '动态设置窗口的背景色',
            url: 'set-background-color/index'
          }
        ]
      },
      {
        id: 'page-tab_bar',
        name: '界面-Tab bar',
        open: false,
        pages: [
          {
            zh: '显示 tabBar',
            url: 'show-tab-bar/index'
          },
          {
            zh: '隐藏 tabBar',
            url: 'hide-tab-bar/index'
          }
        ]
      },
      {
        id: 'page-pull_down_refresh',
        name: '界面-下拉刷新',
        open: false,
        pages: [
          {
            zh: '开始下拉刷新。',
            url: 'start-pull-down-refresh/index'
          },
          {
            zh: '停止当前页面下拉刷新。',
            url: 'stop-pull-down-refresh/index'
          }
        ]
      },
      {
        id: 'page-scroll',
        name: '界面-滚动',
        open: false,
        pages: [
          {
            zh: '将页面滚动到目标位置',
            url: 'page-scroll-to/index'
          }
        ]
      },
      {
        id: 'page-next_tick',
        name: '界面-延迟到Dom更新',
        open: false,
        pages: [
          {
            zh: '延迟一部分操作到下一个时间片再执行',
            url: 'next-tick/index'
          }
        ]
      },
      {
        id: 'page-keyboard',
        name: '界面-键盘',
        open: false,
        pages: [
          {
            zh: '监听键盘高度变化',
            url: 'on-keyboard-height-change/index'
          },
          {
            zh: '隐藏键盘',
            url: 'hide-keyboard/index'
          },
          {
            zh: '获取输入框的光标位置',
            url: 'get-selected-text-range/index'
          }
        ]
      },
      {
        id: 'network-http',
        name: '网络-发起请求',
        open: false,
        pages: [
          {
            zh: '发起 HTTPS 网络请求',
            url: 'request/index'
          }
        ]
      },
      {
        id: 'network-web_socket',
        name: '网络-WebSocket',
        open: false,
        pages: [
          {
            zh: '通过 WebSocket 连接发送数据',
            url: 'send-socket-message/index'
          },
          {
            zh: '监听 WebSocket 连接打开事件',
            url: 'on-socket-open/index'
          },
          {
            zh: '监听 WebSocket 接受到服务器的消息事件',
            url: 'on-socket-message/index'
          },
          {
            zh: '监听 WebSocket 错误事件',
            url: 'on-socket-error/index'
          },
          {
            zh: '监听 WebSocket 连接关闭事件',
            url: 'on-socket-close/index'
          },
          {
            zh: '创建一个 WebSocket 连接',
            url: 'connect-socket/index'
          },
          {
            zh: '关闭 WebSocket 连接',
            url: 'close-socket/index'
          }
        ]
      },
      {
        id: 'network-download',
        name: '网络-下载',
        open: false,
        pages: [
          {
            zh: '下载文件资源到本地',
            url: 'download-file/index'
          }
        ]
      },
      {
        id: 'network-upload',
        name: '网络-上传',
        open: false,
        pages: [
          {
            zh: '将本地资源上传到服务器',
            url: 'upload-file/index'
          }
        ]
      },
      {
        id: 'storage',
        name: '数据缓存',
        open: false,
        pages: [
          {
            zh: '将数据存储在本地缓存中指定的 key 中（同步）',
            url: 'set-storage-sync/index'
          },
          {
            zh: '将数据存储在本地缓存中指定的 key 中（异步）',
            url: 'set-storage/index'
          },
          {
            zh: '从本地缓存中移除指定 key（同步）',
            url: 'remove-storage-sync/index'
          },
          {
            zh: '从本地缓存中移除指定 key（异步）',
            url: 'remove-storage/index'
          },
          {
            zh: '获取当前storage的相关信息（同步）',
            url: 'get-storage-info-sync/index'
          },
          {
            zh: '获取当前storage的相关信息（异步）',
            url: 'get-storage-info/index'
          },
          {
            zh: '从本地缓存中获取指定 key 的内容（同步）',
            url: 'get-storage-sync/index'
          },
          {
            zh: '从本地缓存中获取指定 key 的内容（异步）',
            url: 'get-storage/index'
          },
          {
            zh: '清理本地数据缓存（同步）',
            url: 'clear-storage-sync/index'
          },
          {
            zh: '清理本地数据缓存（异步）',
            url: 'clear-storage/index'
          }
        ]
      },
      {
        id: 'media-image',
        name: '媒体-图片',
        open: false,
        pages: [
          {
            zh: '保存图片到系统相册',
            url: 'save-image-to-photos-album/index'
          }
        ]
      },
      {
        id: 'device-scan_code',
        name: '设备-扫码',
        open: false,
        pages: [
          {
            zh: '调起客户端扫码界面进行扫码',
            url: 'scan-code/index'
          }
        ]
      },
      {
        id: 'location',
        name: '位置',
        open: false,
        pages: [
          {
            zh: '关闭监听实时位置变化',
            url: 'stop-location-update/index'
          },
          {
            zh: '开启小程序进入前后台时均接收位置消息',
            url: 'start-location-update-background/index'
          },
          {
            zh: '开启小程序进入前台时接收位置消息',
            url: 'start-location-update/index'
          },
          {
            zh: '使用地图查看位置',
            url: 'open-location/index'
          },
          {
            zh: '监听实时地理位置变化事件',
            url: 'on-location-change/index'
          },
          {
            zh: '取消监听实时地理位置变化事件',
            url: 'off-location-change/index'
          },
          {
            zh: '获取当前的地理位置、速度',
            url: 'get-location/index'
          },
          {
            zh: '打开地图选择位置',
            url: 'choose-location/index'
          }
        ]
      },
      // {
      //   id: 'current',
      //   name: '当前已实现',
      //   open: false,
      //   pages: [
      //     {
      //       zh: '关闭小程序',
      //       url: 'close-program/index'
      //     },
      //     {
      //       zh: '跳转到 tabBar 页面，并关闭其他所有非 tabBar 页面',
      //       url: 'switch-tab/index'
      //     },
      //     {
      //       zh: '关闭当前页面，跳转到应用内的某个页面',
      //       url: 'redirect-to/index'
      //     },
      //     {
      //       zh: '保留当前页面，跳转到应用内的某个页面',
      //       url: 'navigate-to/index'
      //     },
      //     {
      //       zh: '关闭当前页面，返回上一页面或多级页面。',
      //       url: 'navigate-back/index'
      //     },
      //     {
      //       zh: '关闭所有页面，打开到应用内的某个页面',
      //       url: 're-launch/index'
      //     },
      //     {
      //       zh: '在当前页面显示导航条加载动画',
      //       url: 'show-navigation-bar-loading/index'
      //     },
      //     {
      //       zh: '动态设置当前页面的标题',
      //       url: 'set-navigation-bar-title/index'
      //     },
      //     {
      //       zh: '设置页面导航条颜色',
      //       url: 'set-navigation-bar-color/index'
      //     },
      //     {
      //       zh: '在当前页面隐藏导航条加载动画',
      //       url: 'hide-navigation-bar-loading/index'
      //     },
      //     {
      //       zh: '开始下拉刷新。',
      //       url: 'start-pull-down-refresh/index'
      //     },
      //     {
      //       zh: '停止当前页面下拉刷新。',
      //       url: 'stop-pull-down-refresh/index'
      //     },
      //     {
      //       zh: '显示消息提示框',
      //       url: 'show-toast/index'
      //     },
      //     {
      //       zh: '隐藏消息提示框',
      //       url: 'hide-toast/index'
      //     },
      //     {
      //       zh: '显示模态对话框',
      //       url: 'show-modal/index'
      //     },
      //     {
      //       zh: '显示 loading 提示框',
      //       url: 'show-loading/index'
      //     },
      //     {
      //       zh: '隐藏 loading 提示框',
      //       url: 'hide-loading/index'
      //     },
      //     {
      //       zh: '显示 tabBar',
      //       url: 'show-tab-bar/index'
      //     },
      //     {
      //       zh: '隐藏 tabBar',
      //       url: 'hide-tab-bar/index'
      //     },
      //     {
      //       zh: '发起 HTTPS 网络请求',
      //       url: 'request/index'
      //     },
      //     {
      //       zh: '创建一个 WebSocket 连接',
      //       url: 'connect-web-socket/index'
      //     },
      //     {
      //       zh: '下载文件资源到本地',
      //       url: 'download-file/index'
      //     },
      //     {
      //       zh: '将本地资源上传到服务器',
      //       url: 'upload-file/index'
      //     },
      //     {
      //       zh: '保存图片到系统相册',
      //       url: 'save-image-to-photos-album/index'
      //     },
      //     {
      //       zh: '调起客户端扫码界面进行扫码',
      //       url: 'scan-code/index'
      //     },
      //     {
      //       zh: '将数据存储在本地缓存中指定的 key 中',
      //       url: 'set-storage/index'
      //     },
      //     {
      //       zh: '从本地缓存中移除指定 key',
      //       url: 'remove-storage/index'
      //     },
      //     {
      //       zh: '从本地缓存中异步获取指定 key 的内容',
      //       url: 'get-storage/index'
      //     },
      //     {
      //       zh: '异步获取当前storage的相关信息',
      //       url: 'get-storage-info/index'
      //     },
      //     {
      //       zh: '清理本地数据缓存',
      //       url: 'clear-storage/index'
      //     }
      //   ]
      // }
    ],
    isSetTabBarPage: false,
    defaultTabBarStyle: {
      color: '#7A7E83',
      selectedColor: '#3cc51f',
      backgroundColor: '#ffffff',
    },
    defaultItemName: '接口',
    hasSetTabBarBadge: false,
    hasShownTabBarRedDot: false,
    hasCustomedStyle: false,
    hasCustomedItem: false,
    hasHiddenTabBar: false
  }
},
methods: {
  onShow() {
    this.leaveSetTabBarPage()
  },
  onHide() {
    this.leaveSetTabBarPage()
  },
  kindToggle(id) {
    const list = this.list
    for (let i = 0, len = list.length; i < len; ++i) {
      if (list[i].id === id) {
        if (list[i].url) {
          Bridge.navigateTo({
            url: '/pages/API/' + list[i].url
          })
          return
        }
        list[i].open = !list[i].open
      } else {
        list[i].open = false
      }
    }
    this.list = list
  },
  enterSetTabBarPage() {
    this.isSetTabBarPage = true
  },
  leaveSetTabBarPage() {
    this.isSetTabBarPage = false
  },
  navigateBack() {
    this.triggerEvent('unmount')
  },

  setTabBarBadge() {
    if (this.hasSetTabBarBadge) {
      this.removeTabBarBadge()
      return
    }
    this.hasSetTabBarBadge = true
    Bridge.setTabBarBadge({
      index: 1,
      text: '1',
    })
  },

  removeTabBarBadge() {
    this.hasSetTabBarBadge = false
    Bridge.removeTabBarBadge({
      index: 1,
    })
  },

  showTabBarRedDot() {
    if (this.hasShownTabBarRedDot) {
      this.hideTabBarRedDot()
      return
    }
    this.hasShownTabBarRedDot = true
    Bridge.showTabBarRedDot({
      index: 1
    })
  },

  hideTabBarRedDot() {
    this.hasShownTabBarRedDot = false
    Bridge.hideTabBarRedDot({
      index: 1
    })
  },

  showTabBar() {
    this.hasHiddenTabBar = false
    Bridge.showTabBar()
  },

  hideTabBar() {
    if (this.hasHiddenTabBar) {
      this.showTabBar()
      return
    }
    this.hasHiddenTabBar = true
    Bridge.hideTabBar()
  },

  customStyle() {
    if (this.hasCustomedStyle) {
      this.removeCustomStyle()
      return
    }
    this.hasCustomedStyle = true
    Bridge.setTabBarStyle({
      color: '#FFF',
      selectedColor: '#1AAD19',
      backgroundColor: '#000000',
    })
  },

  removeCustomStyle() {
    this.hasCustomedStyle = false
    Bridge.setTabBarStyle(this.defaultTabBarStyle)
  },

  customItem() {
    if (this.hasCustomedItem) {
      this.removeCustomItem()
      return
    }
    this.hasCustomedItem = true
    Bridge.setTabBarItem({
      index: 1,
      text: 'API'
    })
  },

  removeCustomItem() {
    this.hasCustomedItem = false
    Bridge.setTabBarItem({
      index: 1,
      text: this.defaultItemName
    })
  }
},
watch: {
  isSetTabBarPage(newVal, oldVal) {
    if (newVal) {
      Bridge.pageScrollTo({
        scrollTop: 0,
        duration: 0
      })
    } else {
      this.removeTabBarBadge()
      this.hideTabBarRedDot()
      this.showTabBar()
      this.removeCustomStyle()
      this.removeCustomItem()
    }
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

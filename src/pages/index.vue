<template>
  <div class="indexHome" >
    <div class="MessageBoxHome" v-show="loading">
      <div class="MessageBoxIndex">
        <div class="BoxLoading">
          <img class="logoImg" src="../assets/img/logo1.png" alt/>
          <div v-show="flag3" class="box box1">
            <img src="../assets/img/fail.png" alt/>
            <span v-text="$t('message.text1')">交易被拒绝</span>
            <button class="buttonLoading" @click="againTry()" v-text="$t('message.text2')">再试一次</button>
          </div>
          <div v-show="flag2" class="box box2">
            <img src="../assets/img/loading.gif" alt/>
            <a :href="url" target="_blank">
              <button class="buttonLoading" v-text="$t('message.text3')">查看交易</button>
            </a>
          </div>
          <div v-show="flag1" class="box box3">
            <img src="../assets/img/loading.gif" alt/>
            <button class="buttonLoading" v-text="$t('message.text04')">交易确认中...</button>
          </div>
          <img
              style="cursor:pointer"
              @click="closeMengceng()"
              class="deleteImg"
              src="../assets/img/delete.png"
              alt
          />
        </div>
      </div>
    </div>
      <el-row>
        <el-col :span="12" style="margin:10px auto auto;" :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
          <div style="text-align:center;margin: 0 auto;">
            <button style="z-index: 999;margin: 10px;" class="connectWalletButton buttonBox">
              <span @click="linkWallet()">{{ addressMsg }}</span>
            </button>
            <button class="buttonBox">
              <span @click="openAndClose">关闭连接</span>
            </button>
          </div>
        </el-col>
        <el-col :span="12" style="margin:10px auto auto;" :xs="24" :sm="24" :md="24" :lg="24" :xl="24">
          <div style="text-align:center;margin: 0 auto;">
            操作地址：{{ OperationAddress }}
            <br/>
            <br/>
            当前网络：
            <el-tag type="success">{{ networkId }}</el-tag>
          </div>
        </el-col>
      </el-row>
      <div>
        <router-view ref="son"/>
      </div>
    </div>
</template>

<script>
import {mapMutations} from "vuex";
import {connectWallet, disconnectWallet} from "@/web3/index";

export default {
  data() {
    return {
      flag1: false,
      flag2: false,
      flag3: false,
      loading: false,
      url: "",
      OperationAddress: "",
      networkId: -1,
      activeIndex: "/",
      screenWidth: "",
      addressMsg: "连接钱包",
      hide: false,
      show: false,
      msg: "Google Chrome is recommended",
      msg1: "Please connect your wallet first",
      msg2: "Please enter the amount",
      msg3: "Insufficient balance",
      options: [],
      selectValue: ""
    };
  },
  directives: {
    focus: {
      inserted: function (el) {
        el.focus();
      }
    }
  },

  created() {
    this.selectValue = "cn";
    this.activeIndex = location.pathname; //下标刷新不变,history模式下
    switch (localStorage.getItem("lang")) {
      case "cn":
        this.msg = "推荐使用Google Chrome浏览器";
        this.msg1 = "请先连接钱包";
        this.msg2 = "请输入金额";
        this.msg3 = "余额不足";
        this.addressMsg = "连接钱包";
        break;
      default:
        this.msg = "推荐使用Google Chrome浏览器";
        this.msg1 = "请先连接钱包";
        this.msg2 = "请输入金额";
        this.msg3 = "余额不足";
        this.addressMsg = "连接钱包";
        break;
    }
  },
  methods: {
    ...mapMutations(["updateWallet", "updateAddress", "clearWallet", "updateNetworkId"]),
    openAndClose() {
      disconnectWallet(
          this.$store.state.wallet.web3,
          data => {
          }
      ).then(async () => {
        this.addressMsg = "连接钱包";
        this.OperationAddress = '';
        this.networkId = -1;
        this.options = []
        this.clearWallet();
        this.show1 = false;
      });
    },
    closeMengceng() {
      this.loading = false;
    },
    againTry() {
      this.loading = false;
    },
    // 连接钱包
    async linkWallet() {
      if (this.$store.state.wallet.connected) {
        disconnectWallet(this.$store.state.wallet.web3,(data => {})).then(async () => {
          this.clearWallet();
          await connectWallet(this);
        });
      } else {
        await connectWallet(this);
      }
    },
    // 改变更新数据
    changeUpdate() {
      if (this.$store.state.wallet.connected) {
        console.log('启动'+this.$store.state.wallet.networkId)
        if (!(this.$store.state.wallet.networkId===3476||this.$store.state.wallet.networkId===6794)){
          alert("错误的网络：请使用BHP主网或测试网")
          return
        }
        this.OperationAddress = this.$store.state.wallet.address
        this.networkId = this.$store.state.wallet.networkId
        this.addressMsg = this.$store.state.wallet.address.substr(0, 7)
        this.options = this.$store.state.wallet.addressList
      }
    }
  },
  updated() {
    if (this.$store.state.wallet.connected) {
      //this.changeUpdate();
    }
  },
};
</script>

<style lang="less">

.MessageBoxHome {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  z-index: 1002;
}
.MessageBoxIndex {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}
.BoxLoading {
  width: 29.625rem;
  height: 621px;
  box-sizing: border-box;
  background: url("../assets/img/traLoading.png") no-repeat;
  background-size: cover;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  position: relative;
}

@media (max-width: 640px) {
  .BoxLoading {
    width: 29.625rem;
    height: 621px;
    box-sizing: border-box;
    background: url("../assets/img/traLoading.png") no-repeat;
    background-size: cover;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
    position: relative;
  }
  .buttonLoading {
    width: 375px;
    height: 50px;
    margin-top: 44px;
    background: #ff9900;
    border-radius: 31px;
    font-size: 24px;

    font-weight: 400;
    color: #ffffff;
    border: none;
    padding: 0;
    outline: none;
  }
}

.box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  width: 375px;
  height: 310px;

}
.box img {
  width: 88px;
  height: 88px;
  margin: 60px 0 20px;
}

.box span {
  height: 44px;
  font-size: 24px;
  font-weight: 400;
  color: #ff3d3d;
  line-height: 44px;
}

.box3 button {
  background: #ff9900;
  opacity: 0.39;
}

.box2,.box3 img {
  width: 100px;
}

.logoImg {
  width: 265px;
  height: 65px;
  padding-top: 3.75rem;
  padding-bottom: 40px;
}

.buttonLoading {
  width: 375px;
  height: 50px;
  margin-top: 44px;
  background: #ff9900;
  border-radius: 31px;
  font-size: 24px;

  font-weight: 400;
  color: #ffffff;
  border: none;
  padding: 0;
  outline: none;
}

.deleteImg {
  width: 23px;
  height: 23px;
  position: absolute;
  bottom: 1em;
}

.connectWalletButton {
  position: relative;
  transform: scale(1);
  opacity: 1;

}

.selectWalletDiv span {
  padding: 52px 0 20px 0;
  height: 28px;
  font-size: 20px;

  font-weight: 400;
  color: #1a1a1a;
  line-height: 28px;
}

.imgDiv img {
  width: 40px;
}

.connectWalletButton:hover .selectWalletDiv {
  visibility: visible;
  opacity: 1;
}

.buttonBox {
  width: 184px;
  height: 52px;
  background: #3e3e3e;
  border-radius: 26px;
  cursor: pointer;
  font-size: 20px;
  font-weight: 400;
  color: #ff9900;
}
</style>
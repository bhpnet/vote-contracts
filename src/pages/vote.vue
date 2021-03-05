<template>
  <div class="vault" style="margin: 20px;">
      <el-row :gutter="24">
        <!--   1.创建提案 -->
        <el-col :span="12" style="margin:10px auto auto;" :xs="24" :sm="24" :md="24" :lg="12" :xl="8">
          <el-card class="box-card">
            <div slot="header" class="clearfix">
              <span>1、创建提案</span>
            </div>
            <el-form  label-position="left" label-width="80px">
              <el-form-item label="标题">
                <el-input v-model="name" maxlength="12" placeholder="请输入提案标题" ></el-input>
              </el-form-item>
              <el-form-item label="内容">
                <el-input v-model="name" type="textarea" rows="8" maxlength="12" placeholder="请输入提案内容"></el-input>
              </el-form-item>
              <el-form-item label="时间段">
                <el-date-picker
                    v-model="value1"
                    type="datetimerange"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期"
                    :default-time="['12:00:00']">
                </el-date-picker>
              </el-form-item>
              <el-form-item>
                <el-button type="primary"  @click="createProposal()">创建提案</el-button>
              </el-form-item>
            </el-form>
          </el-card>
        </el-col>
        <!--   2、对提案投票 -->
        <el-col :span="12" style="margin:10px auto auto;" :xs="24" :sm="24" :md="24" :lg="12" :xl="8">
          <el-card>
            <div slot="header" class="clearfix">
              <span>2、对提案投票</span>
            </div>
            <el-form  label-position="left" label-width="80px">
              <el-form-item label="意向">
                <el-radio-group v-model="name">
                  <el-radio label="赞同"></el-radio>
                  <el-radio label="否定"></el-radio>
                </el-radio-group>
              </el-form-item>
              <el-form-item>
                <el-button type="primary"  @click="voteProposal()">提交</el-button>
              </el-form-item>
            </el-form>
          </el-card>
        </el-col>
        <!--   3.添加白名单 -->
        <el-col :span="12" style="margin:10px auto auto;" :xs="24" :sm="24" :md="24" :lg="12" :xl="8">
          <el-card>
            <div slot="header" class="clearfix">
              <span>3、添加白名单</span>
            </div>
            <el-form  label-width="110px" >
              <el-form-item label="地址">
                <el-input v-model="name" maxlength="12" placeholder="请输入要设置的白名单地址" ></el-input>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="getAddressInfo()">提交</el-button>
              </el-form-item>
            </el-form>
          </el-card>
        </el-col>
      </el-row>
      <!--   列表信息 -->
      <el-dialog
          :title="title"
          :visible.sync="dialogTableVisible"
          :width="dialogWidth"
      >
        <el-table :data="tableData">
          <el-table-column
              label="序号"
              type="index"
              align="center"
              width="50">
          </el-table-column>
          <el-table-column
              prop="name"
              align="center"
              label="代号"
              width="200"
          >
          </el-table-column>
          <el-table-column
              prop="address"
              align="center"
              label="地址"
              >
          </el-table-column>
          <el-table-column
              prop="time"
              align="center"
              label="时间"
              width="200"
          >
          </el-table-column>
        </el-table>
      </el-dialog>
      <!--    查看返回结果-->
      <el-dialog
          :title="title"
          :visible.sync="dialogResultVisible"
          :before-close="handleClose"
          :width="dialogWidth"
      >
          <span>{{ info }}</span>
          <span slot="footer" class="dialog-footer">
          <el-button type="primary" @click="dialogResultVisible = false">关闭</el-button>
        </span>
      </el-dialog>
    <!--   地址列表信息 -->
    <el-dialog
        :title="title"
        :visible.sync="dialogTableAddressVisible"
        :width="dialogWidth"
    >
      <el-table :data="tableAddressData">
        <el-table-column
            label="序号"
            type="index"
            align="center"
            width="50">
        </el-table-column>
        <el-table-column
              prop="name"
              align="center"
              label="代号"
              width="200"
        >
        </el-table-column>
        <el-table-column
            prop="address"
            align="center"
            label="地址"
        >
        </el-table-column>
        <el-table-column
            prop="desc"
            align="center"
            label="结果"
            width="180"
        ></el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import {
  prizes,
  getAddressInfo,
  getRewardInfo
} from "@/web3/draw";
import {
  createProposal,
  voteProposal
} from "@/web3/vote";
import {voteAddress} from "@/web3/vote";
import {bhp} from "@/configure/conf";
import BigNumber from "bignumber.js";
export default {
  data() {
    return {
      dialogTableVisible: false,
      dialogTableAddressVisible: false,
      dialogResultVisible: false,
      title:'',
      address:'',
      info:'',
      name:'',
      contractUrl:'',
      contractAddress:'',
      tableData:[],
      tableAddressData:[],
      dialogWidth: 0,
      dialogFormVisible: false,
      formInline: {
        user: '',
        region: ''
      },
      value1:'',
      getValidatorInfoResult:[]
    };
  },
  beforeDestroy() {
    clearInterval(this.timer);
  },
  filters:{
    toBHP:(amount)=>{
        let balance = new BigNumber(amount)
        return balance.div("1000000000000000000").toPrecision(18)
    },
    formatTime:(time)=>{
      return new Date(parseInt(time) * 1000).toLocaleString();
    }
  },
  created() {
    //this.contractAddress=voteAddress.substr(0,10)+"***"+voteAddress.substr(32,42)
    this.contractAddress=voteAddress
    this.contractUrl="https://testnet.bhpnet.io/address/"+voteAddress+"/contracts"
    console.log(voteAddress)
  },
  mounted() {
    window.onresize = () => {
      return (() => {
        this.setDialogWidth()
      })()
    }
  },
  methods: {
    handleClose() {
      this.dialogTableVisible= false
      this.dialogResultVisible=false
    },
    getErrorInfo(result){
      this.title="错误提示"
      this.info=result
      this.dialogResultVisible = true
    },
    verifyConnect(){
      let wallet = this.$store.state.wallet;
      if (!wallet.connected) {
        alert("请先连接钱包");
        return false
      }
      this.address=this.$store.state.wallet.address
      return true
    },
    setDialogWidth() {
      let val = document.body.clientWidth;
      const def = 900 // 默认宽度
      if (val < def) {
        this.dialogWidth = '90%'
      } else {
        this.dialogWidth = def + 'px'
      }
    },
    getPrizeInfo(){
      this.tableAddressData=[]
      if (this.verifyConnect()){
        getRewardInfo(
            this.$store.state.wallet,
            data => {
              console.log(data);
            }
        ).then(res => {
          console.log(res)
          res.forEach(info => {
            let desc
            if(info.prizes==="1"){
              desc="一等奖"
            }else if (info.prizes==="2"){
              desc="二等奖"
            }else{
              desc="三等奖"
            }
            let data={
              address:info.addr,
              desc:desc,
              name:info.name
            }
            this.tableAddressData.push(data)
          })
          this.title="中奖结果"
          this.dialogTableAddressVisible=true

        }).catch(err=>{
          this.getErrorInfo(err)
        })
      }
    },
    createProposal(){
      if (this.verifyConnect()){
        if (this.name===""){
          this.$message({
            showClose: true,
            message: '代号不能为空',
            type: 'warning'
          });
        }else if (this.name.length>12){
          this.$message({
            showClose: true,
            message: '代号不能超过12个字母',
            type: 'warning'
          });
        }else{
          // 查看是否授权
          this.$parent.loading = true;
          this.$parent.flag1 = true;
          this.$parent.flag2 = false;
          this.$parent.flag3 = false;
          createProposal(
              this.$store.state.wallet,
              this.name,
              data => {
                console.log(data);
                this.$parent.url = bhp + data.message;
                this.$parent.flag2 = true;
                this.$parent.flag1 = false;
                this.$parent.flag3 = false;
              }
          ).then(res => {
            this.$parent.loading = false;
            this.title="返回结果"
            this.info="参与成功！"
            this.dialogResultVisible = true
          }).catch(err=>{
            this.$parent.loading = false;
            this.getErrorInfo(err)
          })
        }
      }
    },
    voteProposal(){
      if (this.verifyConnect()){
        // 查看是否授权
        this.$parent.flag1 = true;
        this.$parent.flag2 = false;
        this.$parent.flag3 = false;

        voteProposal(
            this.$store.state.wallet,
            data => {
              console.log(data);
              this.$parent.url = bhp + data.message;
              this.$parent.flag2 = true;
              this.$parent.flag1 = false;
              this.$parent.flag3 = false;
            }
        ).then(res => {
          console.log('是否开奖',res)
          this.prizes(res)
        }).catch(err=>{
          this.getErrorInfo(err)
        })
      }
    },
    prizes(isOpenPrize){
        // 查看是否授权
        this.$parent.flag1 = true;
        this.$parent.flag2 = false;
        this.$parent.flag3 = false;

        prizes(
            this.$store.state.wallet,
            this.address,
            data => {
              this.$parent.url = bhp + data.message;
              this.$parent.flag2 = true;
              this.$parent.flag1 = false;
              this.$parent.flag3 = false;
            }
        ).then(res => {
          let result=res;
          if (result === "0"&&!isOpenPrize){
            this.title="中奖信息"
            this.info="还未开奖"
            this.dialogResultVisible = true
          }else{
            this.title="中奖信息"
            let desc
            if(result==="1"){
              desc="一等奖"
            }else if (result==="2"){
              desc="二等奖"
            }else{
              desc="三等奖"
            }
            this.info="地址："+this.address+"\n 中奖结果："+desc
            this.dialogResultVisible = true
          }
        }).catch(err=>{
          this.getErrorInfo(err)
        })
    },
    getAddressInfo(){
      if (this.verifyConnect()){
        // 查看是否授权
        this.$parent.flag1 = true;
        this.$parent.flag2 = false;
        this.$parent.flag3 = false;
        getAddressInfo(
            this.$store.state.wallet,
            data => {
              this.$parent.url = bhp + data.message;
              this.$parent.flag2 = true;
              this.$parent.flag1 = false;
              this.$parent.flag3 = false;
            }
        ).then(res => {
          console.log(res)
          this.tableData=[]
          res.forEach(info => {
            let data={
              address:info.addr,
              name:info.name.substr(0,12),
              time:new Date(parseInt(info.joinTime) * 1000).toLocaleString()
            }
            this.tableData.push(data)
          })
          this.title="参与人数"
          this.dialogTableVisible=true

        }).catch(err=>{
          this.getErrorInfo(err)
        })
      }
    },
  },
};
</script>

<style lang="less">

</style>
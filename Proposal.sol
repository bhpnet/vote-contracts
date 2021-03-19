pragma solidity >=0.6.0 <0.8.0;

contract Params {
    //是否初始化
    bool public initialized;

    //合约拥有者
    address public owner;
    //白名单
    mapping(address=>bool) public whiteList;

    modifier onlyWhiteList {
        require(whiteList[msg.sender], "WhiteList only");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Owner only");
        _;
    }

    modifier onlyNotInitialized() {
        require(!initialized, "Already initialized");
        _;
    }

    modifier onlyInitialized() {
        require(initialized, "Not init yet");
        _;
    }

}

contract Proposal is Params {

    //提案详情
    struct ProposalInfo {
        // 提案人
        address proposer;
        // 标题
        string title;
        // 提案细节
        string details;
        // 提案创建时间
        uint256 createTime;
        // 提案同意的票数
        uint256 agree;
        // 提案反对的票数
        uint256 reject;
        //投票开始时间
        uint256 votingStartTime;
        //投票结束时间
        uint256 votingEndTime;
    }

    //投票详情
    struct VoteInfo {
        //投票者
        address voter;
        //投票时间
        uint256 voteTime;
        //投票选择
        bool auth;
        //投票权重
        uint256 weight;
    }

    mapping(bytes32 => ProposalInfo) public proposals;
    mapping(address => mapping(bytes32 => VoteInfo)) public votes;
    bytes32[] proposalIds;


    event LogCreateProposal(
        bytes32 indexed id,
        address indexed proposer,
        uint256 time
    );
    event LogVote(
        bytes32 indexed id,
        address indexed voter,
        uint256 weight,
        bool auth,
        uint256 time
    );
    event LogAddWhiteList(
        address indexed addr
    );
    event LogEditProposal(
        bytes32 indexed id,
        address indexed proposer,
        uint256 time
    );


    //初始化
    function initialize() external onlyNotInitialized {
        owner = msg.sender;
        initialized = true;
        whiteList[msg.sender] = true;
    }

    //创建提案
    function createProposal(string calldata _title,string calldata _details, uint256 _votingStartTime, uint256 _votingEndTime)
    external onlyWhiteList onlyInitialized
    {

        // generate proposal id
        bytes32 id = keccak256(
            abi.encodePacked(msg.sender, _title, _details, block.timestamp)
        );
        require(_votingEndTime > block.timestamp, "The end time must be greater than the current time");
        require(_votingEndTime > _votingStartTime, "The end time must be greater than the start time");
        require(bytes(_title).length <= 500, "Title too long");
        require(bytes(_details).length <= 3000, "Details too long");
        require(proposals[id].createTime == 0, "Proposal already exists");

        ProposalInfo memory proposal;
        proposal.proposer = msg.sender;
        proposal.details = _details;
        proposal.createTime = block.timestamp;
        proposal.title = _title;
        proposal.votingStartTime = _votingStartTime;
        proposal.votingEndTime = _votingEndTime;

        proposals[id] = proposal;
        proposalIds.push(id);
        emit LogCreateProposal(id, msg.sender, block.timestamp);
    }

    //投票
    function voteProposal(bytes32 id, bool auth)
    external
    returns (bool)
    {
        require(proposals[id].createTime != 0, "Proposal not exist");
        require(
            votes[msg.sender][id].voteTime == 0,
            "You can't vote for a proposal twice"
        );
        require(
            block.timestamp >= proposals[id].votingStartTime,
            "Proposal no start"
        );
        require(
            block.timestamp <= proposals[id].votingEndTime,
            "Proposal expired"
        );
        require(msg.sender.balance >= 1 ether,"Assets must be greater than 1BHP");

        votes[msg.sender][id].voteTime = block.timestamp;
        votes[msg.sender][id].voter = msg.sender;
        votes[msg.sender][id].auth = auth;
        votes[msg.sender][id].weight = msg.sender.balance;
        emit LogVote(id, msg.sender, msg.sender.balance, auth, block.timestamp);

        // update dst status if proposal is passed
        if (auth) {
            proposals[id].agree = proposals[id].agree + msg.sender.balance;
        } else {
            proposals[id].reject = proposals[id].reject + msg.sender.balance;
        }
        return true;
    }

    //添加白名单
    function addWhiteList(address _addr) external onlyOwner{
        whiteList[_addr] = true;
        emit LogAddWhiteList(_addr);
    }

    //修改提案
    function editProposal(bytes32 _id, string calldata _title,string calldata _details, uint256 _votingStartTime, uint256 _votingEndTime)
    external onlyWhiteList
    {
        require(proposals[_id].proposer == msg.sender, "No such proposer");
        require(_votingEndTime > block.timestamp, "The end time must be greater than the current time");
        require(_votingEndTime > _votingStartTime, "The end time must be greater than the start time");
        require(bytes(_title).length <= 500, "Title too long");
        require(bytes(_details).length <= 3000, "Details too long");

        proposals[_id].title = _title;
        proposals[_id].details = _details;
        proposals[_id].votingStartTime = _votingStartTime;
        proposals[_id].votingEndTime = _votingEndTime;
        emit LogEditProposal(_id, msg.sender, block.timestamp);
    }

    //提案id分页查询
    function proposalIdsList(uint _page, uint _len) external view returns (bytes32[] memory) {
        bytes32[] memory ids = new bytes32[](_len);

        for(uint i = (_len * (_page-1)); i < proposalIds.length && i < (_len * _page); i++) {
            ids[i-(_len * (_page-1))] = proposalIds[i];
        }

        return ids;
    }
}

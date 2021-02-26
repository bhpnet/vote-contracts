pragma solidity >=0.6.0 <0.8.0;

contract Params {
    bool public initialized;
    
    address public owner;
    mapping(address=>bool) public whiteList;
    
    modifier onlyWhiteList {
        require(whiteList[msg.sender]);
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

    struct ProposalInfo {
        // who propose this proposal
        address proposer;
        // optional detail info of proposal
        string details;
        // time create proposal
        uint256 createTime;
        //
        // vote info
        //
        // number agree this proposal
        uint256 agree;
        // number reject this proposal
        uint256 reject;
        // means you can get proposal of current vote.
        bool resultExist;
        string title;               // 标题
        uint256 votingStartTime;
        uint256 votingEndTime;
    }

    struct VoteInfo {
        address voter;
        uint256 voteTime;
        bool auth;
        uint256 weight;
    }

    mapping(bytes32 => ProposalInfo) public proposals;
    mapping(address => mapping(bytes32 => VoteInfo)) public votes;


    event LogCreateProposal(
        bytes32 indexed id,
        address indexed proposer,
        uint256 time
    );
    event LogVote(
        bytes32 indexed id,
        address indexed voter,
        bool auth,
        uint256 time
    );
    event WhiteListAdded(
        address indexed addr
    );
    event LogEditProposal(
        bytes32 indexed id,
        address indexed proposer,
        uint256 time
    );


    function initialize() external onlyNotInitialized {
        owner = msg.sender;
        initialized = true;
    }

    function createProposal(string calldata _title,string calldata _details, uint256 _votingStartTime, uint256 _votingEndTime)
        external onlyWhiteList
    {
        

        // generate proposal id
        bytes32 id = keccak256(
            abi.encodePacked(msg.sender, _title, _details, block.timestamp)
        );
        require(_votingEndTime > block.timestamp, "time error");
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
        emit LogCreateProposal(id, msg.sender, block.timestamp);
    }

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
            block.timestamp < proposals[id].votingEndTime,
            "Proposal expired"
        );
        require(msg.sender.balance >= 10 ether,"no access");
        
        votes[msg.sender][id].voteTime = block.timestamp;
        votes[msg.sender][id].voter = msg.sender;
        votes[msg.sender][id].auth = auth;
        votes[msg.sender][id].weight = msg.sender.balance;
        emit LogVote(id, msg.sender, auth, block.timestamp);

        // update dst status if proposal is passed
        if (auth) {
            proposals[id].agree = proposals[id].agree + msg.sender.balance;
        } else {
            proposals[id].reject = proposals[id].reject + msg.sender.balance;
        }
        return true;
    }
    
    function addWhiteList(address _addr) external onlyOwner{
        whiteList[_addr] = true;
        emit WhiteListAdded(_addr);
    }
    
    function editProposal(bytes32 _id, string calldata _title,string calldata _details, uint256 _votingStartTime, uint256 _votingEndTime)
            external onlyWhiteList
    {
        require(proposals[_id].proposer == msg.sender, "no proposer");
        require(_votingEndTime > block.timestamp, "time error");
        require(bytes(_title).length <= 500, "Title too long");
        require(bytes(_details).length <= 3000, "Details too long");

        proposals[_id].title = _title;
        proposals[_id].details = _details;
        proposals[_id].votingStartTime = _votingStartTime;
        proposals[_id].votingEndTime = _votingEndTime;
        emit LogEditProposal(_id, msg.sender, block.timestamp);
    }
}

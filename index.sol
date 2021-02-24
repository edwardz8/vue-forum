// deploy to Remix after new token - cannot use ERC721Full
// We will be using Solidity version 0.5.3
pragma solidity 0.5.3;
// Importing OpenZeppelin's ERC-721 Implementation
import 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
// Importing OpenZeppelin's SafeMath Implementation
import 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol';

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";


contract CellyCoin is ERC721Full {
    using SafeMath for uint256;
    // This struct will be used to represent one Celly
    struct Celly {
        uint8 traits;
        uint256 goldenMapleId;
        uint256 darkMapleId;
    }
    
    // List of existing cellys ( all hockey gear )
    Celly[] public cellys;

    // Event that will be emitted whenever a new Celly is created
    event Pour(
        address owner,
        uint256 cellyId,
        uint256 goldenMapleId,
        uint256 darkMapleId,
        uint8 traits
    );

    // Initializing an ERC-721 Token named 'cellys' with a symbol 'CELLY'
    constructor() ERC721Full("cellys", "CELLY") public {
    }

    // Fallback function
    function() external payable {
    }

    /** @dev Function to determine a cellys characteristics.
      * @param goldenMaple ID of cellys goldenMaple (one parent)
      * @param darkMaple ID of cellys darkMaple (other parent)
      * @return The cellys traits in the form of uint8
      */
    function generateCellyTraits(
        uint256 goldenMaple,
        uint256 darkMaple
    )
        internal
        pure
        returns (uint8)
    {
        return uint8(goldenMaple.add(darkMaple)) % 6 + 1;
    }

    /** @dev Function to create a new Celly
      * @param goldenMaple ID of new cellys goldenMaple (one parent)
      * @param darkMaple ID of new cellys darkMaple (other parent)
      * @param CellyOwner Address of new cellys owner
      * @return The new cellys ID
      */
    function createCelly(
        uint256 goldenMaple,
        uint256 darkMaple,
        address CellyOwner
    )
        internal
        returns (uint)
    {
        require(CellyOwner != address(0));
        uint8 newtraits = generateCellyTraits(goldenMaple, darkMaple);
        Celly memory newCelly = Celly({
            traits: newtraits,
            goldenMapleId: goldenMaple,
            darkMapleId: darkMaple
        });
        uint256 newCellyId = cellys.push(newCelly).sub(1);
        super._mint(CellyOwner, newCellyId);
        emit Pour(
            CellyOwner,
            newCellyId,
            newCelly.goldenMapleId,
            newCelly.darkMapleId,
            newCelly.traits
        );
        return newCellyId;
    }
    
    /** @dev Function to allow user to buy a new Celly (calls createCelly())
      * @return The new cellys ID
      */
    function buyCelly() external payable returns (uint256) {
        require(msg.value == 0.02 ether);
        return createCelly(0, 0, msg.sender);
    }
    
    /** @dev Function to Pour 2 cellys to create a new one
      * @param goldenMapleId ID of new cellys goldenMaple (one parent)
      * @param darkMapleId ID of new cellys darkMaple (other parent)
      * @return The new cellys ID
      */
    function pourCellys(uint256 goldenMapleId, uint256 darkMapleId) external payable returns (uint256) {
        require(msg.value == 0.05 ether);
        return createCelly(goldenMapleId, darkMapleId, msg.sender);
    }
    
    /** @dev Function to retrieve a specific cellys details.
      * @param cellyId ID of the Celly who's details will be retrieved
      * @return An array, [cellys ID, cellys traits, goldenMaple's ID, darkMaple's ID]
      */
    function getCellyDetails(uint256 cellyId) external view returns (uint256, uint8, uint256, uint256) {
        Celly storage Celly = cellys[cellyId];
        return (cellyId, Celly.traits, Celly.goldenMapleId, Celly.darkMapleId);
    }
    
    /** @dev Function to get a list of owned cellys' IDs
      * @return A uint array which contains IDs of all owned cellys
      */
    function ownedCellys() external view returns(uint256[] memory) {
        uint256 CellyCount = balanceOf(msg.sender);
        if (CellyCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](CellyCount);
            uint256 totalCellys = cellys.length;
            uint256 resultIndex = 0;
            uint256 cellyId = 0;
            while (cellyId < totalCellys) {
                if (ownerOf(cellyId) == msg.sender) {
                    result[resultIndex] = cellyId;
                    resultIndex = resultIndex.add(1);
                }
                cellyId = cellyId.add(1);
            }
            return result;
        }
    }
}
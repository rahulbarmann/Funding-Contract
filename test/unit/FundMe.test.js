const { assert } = require("chai");
const { getNamedAccounts, deployments, ethers } = require("hardhat");

describe("FundMe", async () => {
    let fundMe;
    let deployer;
    let mockV3Aggregator;
    beforeEach(async () => {
        deployer = (await getNamedAccounts()).deployer; // fetches the deployer address from the named accounts object and assigns it to the variable deployer
        console.log("deployer: ", deployer);
        await deployments.fixture(["all"]);
        console.log("deployed");
        fundMe = await ethers.getContractAt("FundMe", deployer);
        mockV3Aggregator = await ethers.getContractAt(
            "MockV3Aggregator",
            deployer
        );
    });

    describe("constructor", async () => {
        it("sets the aggregator address correctly", async () => {
            const response = await fundMe.priceFeedAddress();
            console.log(reponse, mockV3Aggregator.address);
            assert.equal(response, mockV3Aggregator.address);
        });
    });
});

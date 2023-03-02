import React from 'react'
import { ethers } from 'ethers'
const NFT_ADDRESS = '0xB9e76f90838CaaFEcb601754fbd2B112D513869a' // NFT contract address
const AUCTIONMANAGER_ADDRESS = '0x0cc272d5EeE3997834A177921135A962d2d00b71' // AuctionManager contract address
class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      auctions: [], // Auctions to display
      newAuction: {
        // newAuction is a state variable for the form
        startPrice: null,
        endTime: null,
        tokenId: null,
        minIncrement: null,
        directBuyPrice: null,
      },
      myItems: [],
    }
  }
  render() {
    return (
      <div>
        <div class="jumbotron d-flex align-items-center">
          <form>
            <div class="mb-3">
              <label for="startprice" class="form-label">
                Start Price
              </label>
              <input
                value={this.state.newAuction.startPrice}
                onChange={(e) =>
                  this.setState({
                    newAuction: {
                      ...this.state.newAuction,
                      startPrice: parseInt(e.target.value),
                    },
                  })
                }
                type="number"
                class="form-control"
                id="startprice"
              />
              <label for="startprice" class="form-label">
                Token Id
              </label>
              <input
                value={this.state.newAuction.tokenId}
                onChange={(e) =>
                  this.setState({
                    newAuction: {
                      ...this.state.newAuction,
                      tokenId: parseInt(e.target.value),
                    },
                  })
                }
                type="number"
                class="form-control"
                id="startprice"
              />
              <label class="form-label">Minimum Increment</label>
              <input
                value={this.state.newAuction.minIncrement}
                onChange={(e) =>
                  this.setState({
                    newAuction: {
                      ...this.state.newAuction,
                      minIncrement: parseInt(e.target.value),
                    },
                  })
                }
                type="number"
                class="form-control"
              />
              <label class="form-label">Direct Buy Price</label>
              <input
                value={this.state.newAuction.directBuyPrice}
                onChange={(e) =>
                  this.setState({
                    newAuction: {
                      ...this.state.newAuction,
                      directBuyPrice: parseInt(e.target.value),
                    },
                  })
                }
                type="number"
                class="form-control"
              />

              <label class="form-label">Duration In Minutes</label>
              <input
                value={this.state.newAuction.endTime}
                onChange={(e) =>
                  this.setState({
                    newAuction: {
                      ...this.state.newAuction,
                      endTime: parseInt(e.target.value),
                    },
                  })
                }
                type="number"
                class="form-control"
              />
            </div>
          </form>
          <div class="container">
            <div class="auctions row"></div>
          </div>
        </div>

        <div class="container">
          <button
            type="button"
            onClick={() => console.log(this.state.newAuction)}
            class="btn btn-primary"
          >
            Create Auction
          </button>
          <button class="btn btn-fanger">Mint NFT</button>
          <p>
            Your items
            <br />
            {(this.state.myItems || ['']).map((x) => `id: ${x} `) || ''}
          </p>
        </div>
      </div>
    )
  }
}
export default App

declare module "@salesforce/apex/OfferCmpController.getInitialData" {
  export default function getInitialData(param: {offerId: any}): Promise<any>;
}
declare module "@salesforce/apex/OfferCmpController.rejectOffer" {
  export default function rejectOffer(param: {offerId: any, reason: any}): Promise<any>;
}
declare module "@salesforce/apex/OfferCmpController.generateOpportunity" {
  export default function generateOpportunity(param: {offerId: any, obs: any}): Promise<any>;
}

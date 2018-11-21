Savepoint sp = Database.setSavepoint();
try {
    renumberBundle('< bundle id here>', 20, TRUE, 10);
} catch(Exception e) {
    Database.rollback(sp);
    System.debug('## ERROR '+e);
}

private void renumberBundle(Id bundleId, Integer newBundleNumber, Boolean renumberFeatures, Integer step) {
    Product2 bundle = new Product2(Id = bundleId);
    bundle.SBQQ__SortOrder__c = newBundleNumber;
    update bundle;
    
    if(renumberFeatures) {
        Integer featureNumber = step;
        
        for(SBQQ__ProductFeature__c feature : [SELECT Id FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: bundleId ORDER BY CREATEDDATE ASC]) {
            renumberFeature(feature.Id, featureNumber, step);
            featureNumber += step;
        }
    }
}


/**
*	@role update feature number along with the related product options.
*/
private void renumberFeature(Id featureId, Integer newFeatureNumber, Integer step) {
	SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c(Id = featureId);
	feature.SBQQ__Number__c = newFeatureNumber;
	update feature;
	
	List<SBQQ__ProductOption__c> options = [SELECT ID, SBQQ__Number__c FROM SBQQ__ProductOption__c WHERE SBQQ__Feature__c = :featureId ORDER BY CREATEDDATE ASC];
	Integer optionNumber = step;
	for(SBQQ__ProductOption__c opt : options) {
		opt.SBQQ__Number__c = optionNumber;
		optionNumber += step;
	}
	update options;
}

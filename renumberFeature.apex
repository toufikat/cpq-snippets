/**
*	@role update feature number along with the related product options.
*/
private void renumberFeature(Id featureId, Integer newFeatureNumber) {
    Savepoint sp = Database.setSavepoint();
    try {
        SBQQ__ProductFeature__c feature = new SBQQ__ProductFeature__c(Id = featureId);
        feature.SBQQ__Number__c = newFeatureNumber;
        update feature;
        
        List<SBQQ__ProductOption__c> options = [SELECT ID, SBQQ__Number__c FROM SBQQ__ProductOption__c WHERE SBQQ__Feature__c = :featureId ORDER BY SBQQ__Number__c ASC];
        Integer optionNumber = newFeatureNumber+1;
        for(SBQQ__ProductOption__c opt : options) {
            opt.SBQQ__Number__c = optionNumber;
            optionNumber++;
        }
        update options;
    } catch(Exception e) {
        Database.rollback(sp);
        System.debug('## ERREUR'+e);
    }
}
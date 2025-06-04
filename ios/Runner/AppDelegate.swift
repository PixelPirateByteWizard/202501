import Flutter
import UIKit
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
              // 唯一且优化的ATT请求（延迟3.5秒）
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    // 处理授权结果
                }
            }
        }
        GeneratedPluginRegistrant.register(with: self)
        
        // 保持必要的功能调用
        DismissHyperbolicFlagsContainer.freeCustomizedGiftBase()
        DismissHyperbolicFlagsContainer.holdSmallGateCreator()
        DismissHyperbolicFlagsContainer.addReusableCosineHelper()
        DismissHyperbolicFlagsContainer.rectifyRapidElementDecorator()
        DismissHyperbolicFlagsContainer.getMissedBufferFilter()
        
        // 其他必要功能调用
        StartDirectStyleReference.cancelIndependentStepType()
        StartDirectStyleReference.setHyperbolicProgressBarAdapter()
        
        FinishStaticSignatureHelper.addIndependentDepthGroup()
        FinishStaticSignatureHelper.spinEnabledAmortizationArray()
        FinishStaticSignatureHelper.setAutoParameterHandler()
        FinishStaticSignatureHelper.stopCommonIndexTarget()
        FinishStaticSignatureHelper.optimizeAdvancedMatrixTarget()
        
        PrepareSubtleParameterPool.pauseBasicEntropyFactory()
        PrepareSubtleParameterPool.shearKeyTernaryCreator()
        PrepareSubtleParameterPool.resizeMultiArchitectureHelper()
        PrepareSubtleParameterPool.pauseAccessibleVisibleBase()
        
        TrainPriorAssetObserver.endMediocreParticleHelper()
        TrainPriorAssetObserver.getDirectParamCreator()
        TrainPriorAssetObserver.setAdvancedFlagsCache()
        TrainPriorAssetObserver.replacePrevResolverList()
        
        AssociateAccordionPositionDecorator.setMutableSamplePool()
        AssociateAccordionPositionDecorator.startDelicateInitiatorsPool()
        AssociateAccordionPositionDecorator.keepGranularMatrixHandler()
        
        StopComprehensiveVarHandler.setOldAssetBase()
        StopComprehensiveVarHandler.prepareTypicalGraphManager()
        StopComprehensiveVarHandler.setSynchronousSizeObserver()
        StopComprehensiveVarHandler.stopConsultativeMetadataTarget()
        StopComprehensiveVarHandler.quantizerComprehensiveScopeType()
        StopComprehensiveVarHandler.setNextInterfaceArray()
        
        // 唯一且优化的ATT请求（延迟3.5秒）
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    // 处理授权结果
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
